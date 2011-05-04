class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string :name
      t.string :artist
      t.string :album
      t.integer :year
      t.string :genre
      t.float :duration

      t.timestamps
    end
  end

  def self.down
    drop_table :tracks
  end
end
