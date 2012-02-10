class AddStatusToRadios < ActiveRecord::Migration
  def self.up
    add_column :radios, :status, :integer # enum (play, pause, stop)
  end

  def self.down
    remove_column :radios, :status
  end
end
