class CreateErrors < ActiveRecord::Migration
  def self.up
    create_table :errors do |t|
      t.string  :msg, :file, :module
      t.integer :code, :line
      t.text    :details
      t.timestamps
    end
    create_table :error_translations do |t|
      t.references :error
      t.string    :locale, :msg
      t.text      :details
      t.timestamps
    end
    add_index :error_translations, :error_id, :name => 'index_error_translations_on_error_id'
    #Error.create_translation_table! :msg => :string, :details => :text
  end

  def self.down
    #Error.drop_translation_table!
    remove_index :error_translations
    drop_table :error_translations
    drop_table :errors
  end
end
