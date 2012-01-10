class RemoveAlternativeIdFromAnswer < ActiveRecord::Migration
  def self.up
    remove_column :answers, :alternative_id
    add_column :answers, :choices, :string
  end

  def self.down
    remove_column :answers, :choices
    add_column :answers, :alternative_id, :integer
  end
end