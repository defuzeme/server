# == Schema Information
#
# Table name: errors
#
#  code       :integer
#  created_at :datetime
#  details    :text
#  file       :string(255)
#  id         :integer       not null, primary key
#  line       :integer
#  module     :string(255)
#  msg        :string(255)
#  updated_at :datetime
#

class Error < ActiveRecord::Base
  translates :msg, :details
  
  validates :code,
    :presence => true,
    :uniqueness => true,
    :numericality => {:less_than => 0xFFFFFF}
  
  has_many :instances, :class_name => 'ErrorInstance', :dependent => :destroy
  
  def editable_by? user
    user and user.admin?
  end
  
  def to_param
    hex_code
  end
  
  def self.find_by_hex_code hex
    find_by_code hex.to_i(16)
  end
  
  def hex_code
    code.to_s(16).upcase
  end
end
