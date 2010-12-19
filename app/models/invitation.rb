# == Schema Information
#
# Table name: invitations
#
#  accepted_at :datetime
#  created_at  :datetime
#  creator_id  :integer
#  email       :string(255)
#  id          :integer       not null, primary key
#  message     :string(255)
#  new_user_id :integer
#  opened_at   :datetime
#  radio_id    :integer
#  sent_at     :datetime
#  token       :string(255)
#  updated_at  :datetime
#

class Invitation < ActiveRecord::Base
  TOKEN_LENGTH = 10

  validates_presence_of :creator_id

  validates :token,
            :presence => true,
            :length => { :within => 8..30 },
            :uniqueness => true,
            :format => { :with => /[a-z][0-9]+/i }

  validates :email,
            :presence   => true,
            :uniqueness => true,
            :format     => { :with => Authentication.email_regex },
            :length     => { :within => 6..50 }

  attr_accessor :link_radio
  attr_accessible :email, :message, :link_radio, :creator

  belongs_to :creator, :class_name => 'User'
  belongs_to :radio
  belongs_to :new_user, :class_name => 'User'

  scope :ordered, :order => 'accepted_at DESC nulls last, opened_at DESC nulls last, sent_at DESC nulls last'
  scope :pending, :conditions => {:accepted_at => nil}
  
  before_validation :generate_token, :on => :create
  before_create :assign_radio
  after_create :charge_creator
  
  validate :validates_no_existing_user, :on => :create
  
  def to_param
    token
  end
  
  # mark the invitation as opened (link clicked)
  def open!
    update_attribute :opened_at, Time.now if opened_at.blank?
  end
  
  def send!
    UserMailer.invitation(self).deliver
    update_attribute :sent_at, Time.now
  end
  
  # when the new_user is set, accepted_at take the current date
  def new_user= u
    self.accepted_at ||= Time.now
    write_attribute :new_user_id, u.id
  end
  
  # generate a random unique token
  def generate_token length = TOKEN_LENGTH
    begin
      self.token = rand(36**length).to_s(36)
    end while Invitation.find_by_token(self.token)
  end
  
  protected
  
  def assign_radio
    self.radio = creator.radio if link_radio == '1'
    true
  end
  
  def validates_no_existing_user
    if User.find_by_email(email)
      errors[:email] << I18n.t(:already_registered, :scope => [:activerecord, :errors, :messages])
    end
  end
  
  def charge_creator
    creator.decrement! :invitations_left
  end
end
