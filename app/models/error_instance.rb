# == Schema Information
#
# Table name: error_instances
#
#  count      :integer       default(1)
#  created_at :datetime
#  error_id   :integer
#  id         :integer       not null, primary key
#  msg        :text
#  report     :string(255)
#  updated_at :datetime
#  user_id    :integer
#

class ErrorInstance < ActiveRecord::Base

  validates_presence_of :error_id

  validates :count,
    :numericality => {:greater_than => 0}

  belongs_to :user
  belongs_to :error
  
  scope :today, :conditions => ['created_at >= ?', Date.today]
end
