class AddKindToQuestion < ActiveRecord::Migration
  def self.up
    add_column :questions, :kind, :string
  end

  def self.down
    remove_column :questions, :kind
  end
end