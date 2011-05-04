# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110423184127) do

  create_table "invitations", :force => true do |t|
    t.integer  "creator_id"
    t.integer  "radio_id"
    t.integer  "new_user_id"
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "accepted_at"
    t.string   "token"
    t.string   "message"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["creator_id"], :name => "index_invitations_on_creator_id"
  add_index "invitations", ["new_user_id"], :name => "index_invitations_on_new_user_id"
  add_index "invitations", ["radio_id"], :name => "index_invitations_on_radio_id"
  add_index "invitations", ["token"], :name => "index_invitations_on_token"

  create_table "queue_elems", :force => true do |t|
    t.integer  "track_id"
    t.integer  "radio_id"
    t.integer  "position"
    t.datetime "played_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "radios", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.string   "website"
    t.float    "frequency"
    t.integer  "band"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "radios", ["permalink"], :name => "index_radios_on_permalink", :unique => true

  create_table "tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "machine"
    t.datetime "expires_at"
    t.datetime "last_use_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tokens", ["token"], :name => "index_tokens_on_token"

  create_table "tracks", :force => true do |t|
    t.string   "name"
    t.string   "artist"
    t.string   "album"
    t.integer  "year"
    t.string   "genre"
    t.float    "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 50
    t.string   "email",                     :limit => 50
    t.string   "first_name",                :limit => 40
    t.string   "last_name",                 :limit => 40
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.string   "activation_code",           :limit => 40
    t.boolean  "admin",                                   :default => false
    t.datetime "activated_at"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "radio_id"
    t.integer  "invitations_left"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
