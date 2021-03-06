class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users" do |t|
      t.string :login, :email, :limit => 50
      t.string :first_name, :last_name, :limit => 40
      t.string :crypted_password, :salt, :remember_token, :activation_code, :limit => 40
      t.boolean :admin, :default => false
      t.datetime :activated_at, :remember_token_expires_at
      t.timestamps
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
