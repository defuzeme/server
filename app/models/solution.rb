# == Schema Information
#
# Table name: solutions
#
#  created_at :datetime
#  error_id   :integer
#  id         :integer       not null, primary key
#  text       :text
#  updated_at :datetime
#

class Solution < ActiveRecord::Base
  translates :text
  
  validates :text, :presence => true
  
  has_and_belongs_to_many :linked_errors, :class_name => 'Error'
  
  def editable_by? user
    user and user.admin?
  end
  
  def name
    text.split(/\n/).first
  end
end
