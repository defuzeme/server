class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string :name, :artist, :album, :album_artist, :genre
      t.integer :year, :duration
      t.text :properties
      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
