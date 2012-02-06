class AddPriorityToSolutions < ActiveRecord::Migration
  def self.up
    add_column :solutions, :priority, :integer, :default => 5
    Solution.update_all :priority => 5
  end

  def self.down
    remove_column :solutions, :priority
  end
end
