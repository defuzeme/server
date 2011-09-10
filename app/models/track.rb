# == Schema Information
#
# Table name: tracks
#
#  album      :string(255)
#  artist     :string(255)
#  created_at :datetime
#  duration   :float
#  genre      :string(255)
#  id         :integer       not null, primary key
#  name       :string(255)
#  updated_at :datetime
#  year       :integer
#

class Track < ActiveRecord::Base
  has_many :queue_elems
  
  validates :name,
    :presence => true,
    :uniqueness => {:scope => [:artist, :album]}
  validates :duration,
    :presence => true,
    :numericality => {:greater_than => 0}

  # fetch existing track by name, artist & album
  def self.fetch args = {}
    find_or_create_by_name_and_album_and_artist(args)
  end
end
