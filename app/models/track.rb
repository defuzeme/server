# == Schema Information
#
# Table name: tracks
#
#  album        :string(255)
#  album_artist :string(255)
#  artist       :string(255)
#  created_at   :datetime
#  duration     :integer
#  genre        :string(255)
#  id           :integer       not null, primary key
#  properties   :text
#  title        :string(255)
#  track        :integer
#  uid          :integer
#  updated_at   :datetime
#  year         :integer
#

class Track < ActiveRecord::Base
  has_many :queue_elems
  
  validates :title,
    :presence => true,
    :uniqueness => {:scope => [:artist, :album]}

  serialize :properties

  # fetch existing track by name, artist & album
  def self.fetch args = {}
    find_or_create_by_title_and_album_and_artist(args)
  end
end
