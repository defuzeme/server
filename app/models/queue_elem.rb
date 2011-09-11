# == Schema Information
#
# Table name: queue_elems
#
#  created_at :datetime
#  id         :integer       not null, primary key
#  kind       :string(255)
#  play_at    :datetime
#  position   :integer
#  properties :text
#  radio_id   :integer
#  track_id   :integer
#  updated_at :datetime
#

class QueueElem < ActiveRecord::Base
  belongs_to :track
  belongs_to :radio

  serialize :properties
  acts_as_list :scope => :radio
  
  validates_presence_of :track, :radio
  
  scope :played, :conditions => {:position => nil}
  scope :queued, :conditions => 'position IS NOT NULL'
  
  # Return the first list element (position = 1)
  def self.current
    where(:position => 1).first
  end
  
  # Remove the track from the playing queue,
  # and store the playing date for the historic
  def pop! date = Time.now - track.duration
    self.played_at = date
    remove_from_list
  end

  def editable_by? user
    user and radio.editable_by? user
  end

  def track_attributes= args
    self.track = Track.fetch args
  end
  
  # return a scope to elems of the same radio
  def friends
    self.class.where(:radio_id => radio_id)
  end
end
