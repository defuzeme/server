# == Schema Information
#
# Table name: queue_elems
#
#  created_at :datetime
#  id         :integer       not null, primary key
#  played_at  :datetime
#  position   :integer
#  radio_id   :integer
#  track_id   :integer
#  updated_at :datetime
#

class QueueElem < ActiveRecord::Base
  belongs_to :track
  belongs_to :radio

  acts_as_list :scope => :radio
  
  validates_presence_of :track, :radio
  validates_presence_of :played_at, :if => 'position.blank?'
  validates_presence_of :position, :if => 'played_at.blank?'
end
