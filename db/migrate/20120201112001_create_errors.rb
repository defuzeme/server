class CreateErrors < ActiveRecord::Migration
  def self.up
    create_table :errors do |t|
      t.string  :msg, :file, :module
      t.integer :code, :line
      t.text    :details
      t.timestamps
    end
    Error.create_translation_table! :msg => :string, :details => :text
  end

  def self.down
    Error.drop_translation_table!
    drop_table :errors
  end
end
