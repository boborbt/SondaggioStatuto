class AddKindToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :num_choices, :integer
  end

  def self.down
    remove_column :questions, :num_choices
  end
end