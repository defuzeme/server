# == Schema Information
#
# Table name: solutions
#
#  created_at :datetime
#  error_id   :integer
#  id         :integer       not null, primary key
#  priority   :integer       default(5)
#  text       :text
#  updated_at :datetime
#

class Solution < ActiveRecord::Base
  translates :text
  
  validates :text, :presence => true
  validates :priority, :numericality => true
  
  has_and_belongs_to_many :linked_errors, :class_name => 'Error'
  
  default_scope :order => 'priority DESC'
  
  def editable_by? user
    user and user.admin?
  end
  
  def html
    RedCloth.new(text).to_html
  end
  
  def name
    text.split(/\n/).first
  end
end
