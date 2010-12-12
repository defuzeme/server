class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.references :creator, :radio, :new_user
      t.datetime :sent_at, :opened_at, :accepted_at
      t.string :token, :message, :email
      t.timestamps
    end
    add_index :invitations, :creator_id
    add_index :invitations, :radio_id
    add_index :invitations, :new_user_id
    add_index :invitations, :token
  end

  def self.down
    remove_index :invitations, :token
    remove_index :invitations, :new_user_id
    remove_index :invitations, :radio_id
    remove_index :invitations, :creator_id
    drop_table :invitations
  end
end