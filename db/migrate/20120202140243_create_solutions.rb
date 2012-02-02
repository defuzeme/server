class CreateSolutions < ActiveRecord::Migration
  def self.up
    create_table :solutions do |t|
      t.references :error
      t.text :text
      t.timestamps
    end
    create_table :errors_solutions, :id => false do |t|
      t.references :error, :solution
    end
    Solution.create_translation_table! :text => :text
  end

  def self.down
    Solution.drop_translation_table!
    drop_table :errors_solutions
    drop_table :solutions
  end
end
