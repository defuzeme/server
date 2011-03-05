# == Schema Information
#
# Table name: tokens
#
#  created_at  :datetime
#  expires_at  :datetime
#  id          :integer       not null, primary key
#  last_use_at :datetime
#  machine     :string(255)
#  token       :string(255)
#  updated_at  :datetime
#  user_id     :integer
#

class Token < ActiveRecord::Base
  TOKEN_LENGTH = 16
  TOKEN_FORMAT = /[a-z0-9\-_]+/i
  TOKEN_VALIDITY = 2.months

  validates :token,
    :presence => true,
    :uniqueness => true,
    :length => {:is => TOKEN_LENGTH},
    :format => {:with => TOKEN_FORMAT}

  validates_presence_of :user, :expires_at, :last_use_at

  serialize :machine

  belongs_to :user

  before_validation :initialize!, :on => :create

  def attributes options = {}
    { 'token' => token,
      'machine' => machine,
      'expires_at' => expires_at,
      'created_at' => created_at
    }
  end

  def initialize!
    generate_token!
    self.last_use_at = Time.now
    self.expires_at = TOKEN_VALIDITY.from_now
  end

  def generate_token! length = TOKEN_LENGTH
    begin
      self.token = rand(36**length).to_s(36)
    end while Token.find_by_token(self.token)
  end
  
  def to_param
    token
  end
end
