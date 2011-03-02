# == Schema Information
#
# Table name: users
#
#  activated_at              :datetime
#  activation_code           :string(40)
#  admin                     :boolean
#  created_at                :datetime
#  crypted_password          :string(40)
#  email                     :string(50)
#  first_name                :string(40)
#  id                        :integer       not null, primary key
#  last_name                 :string(40)
#  login                     :string(50)
#  radio_id                  :integer
#  remember_token            :string(40)
#  remember_token_expires_at :datetime
#  salt                      :string(40)
#  updated_at                :datetime
#

require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  INVITATIONS_PER_USER = 5

  attr_accessor :invitation_code

  validates :login,
    :presence   => true,
    :uniqueness => true,
    :length     => { :within => 3..50 },
    :format     => { :with => /[a-z0-9\-_]+/i }

  validates :first_name, :last_name,
    :format     => { :with => Authentication.name_regex },
    :length     => { :maximum => 40 },
    :allow_nil  => true

  validates :email,
    :presence   => true,
    :uniqueness => true,
    :format     => { :with => Authentication.email_regex },
    :length     => { :within => 6..50 }

  belongs_to :radio
  has_many :invitations, :foreign_key => :creator_id, :dependent => :nullify
  has_one :invitation, :foreign_key => :new_user_id, :dependent => :nullify

  before_create :make_activation_code
  before_validation :set_default_values, :on => :create
  after_create :update_invitation
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :invitation_code, :first_name, :last_name

  def to_param
    login
  end

  def name
    if first_name.present? or last_name.present?
      "#{first_name} #{last_name}"
    else
      login
    end
  end

  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(:validate => false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  def radio?
    radio_id?
  end

  def self.authenticate(login, password)
    return nil if login.blank? or password.blank?
    u = where(['login = ? and activated_at IS NOT NULL', login]).first # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def editable_by? user
    user and (user.admin? or user == self)
  end

  protected
    
  def make_activation_code
    self.activation_code = self.class.make_token
  end
  
  def set_default_values
    self.invitations_left = INVITATIONS_PER_USER
    self.invitation = Invitation.pending.find_by_token(invitation_code)
    if invitation.present?
      self.radio = invitation.radio
    else
      errors[:invitation_code] << I18n.t("activerecord.errors.messages.invalid") unless admin?
    end
  end
  
  def update_invitation
    if invitation
      invitation.new_user_id = id
      invitation.accepted_at = Time.now
      invitation.save
    end
  end
end
