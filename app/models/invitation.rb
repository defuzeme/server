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

  belongs_to :creator, :class_name => 'User'
  belongs_to :radio
  belongs_to :new_user, :class_name => 'User'
  
  before_validation :generate_token, :on => :create
  
  # mark the invitation as opened (link clicked)
  def open!
    update_attribute :opened_at, Time.now
  end
  
  def send!
    UserMailer.invitation(self).deliver
    update_attribute :sent_at, Time.now
  end
  
  # when the new_user is set, accepted_at take the current date
  def new_user= u
    self.accepted_at ||= Time.now
    write_attribute :new_user, u
  end
  
  # generate a random unique token
  def generate_token length = TOKEN_LENGTH
    begin
      self.token = rand(36**length).to_s(36)
    end while Invitation.find_by_token(self.token)
  end
end
