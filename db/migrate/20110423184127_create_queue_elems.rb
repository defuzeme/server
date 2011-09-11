class CreateQueueElems < ActiveRecord::Migration
  def self.up
    create_table :queue_elems do |t|
      t.references :track, :radio
      t.string :kind
      t.text :properties
      t.integer :position
      t.datetime :play_at
      t.timestamps
    end
  end

  def self.down
    drop_table :queue_elems
  end
end
