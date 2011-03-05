class CreateTokens < ActiveRecord::Migration
  def self.up
    create_table :tokens do |t|
      t.references  :user
      t.string  :token, :machine
      t.datetime  :expires_at, :last_use_at
      t.timestamps
    end
    add_index :tokens, :token
  end

  def self.down
    remove_index :tokens, :token
    drop_table :tokens
  end
end
