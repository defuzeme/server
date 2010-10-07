class CreateRadios < ActiveRecord::Migration
  def self.up
    create_table :radios do |t|
      t.references :user
      t.string :name, :permalink, :website
      t.float :frequency # 98.2 
      t.integer :band # enum (AM FM, etc.)
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :radios
  end
end
