class CreateErrorInstances < ActiveRecord::Migration
  def self.up
    create_table :error_instances do |t|
      t.references :user, :error
      t.text :msg
      t.integer :count, :default => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :error_instances
  end
end
