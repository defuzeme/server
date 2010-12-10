class CreateRadios < ActiveRecord::Migration
  def self.up
    create_table :radios do |t|
      t.string :name, :permalink, :website
      t.float :frequency # 98.2 
      t.integer :band # enum (AM FM, etc.)
      t.text :description
      t.timestamps
    end
    add_column :users, :radio_id, :integer
  end

  def self.down
    remove_column :users, :radio_id rescue nil
    drop_table :radios
  end
end
