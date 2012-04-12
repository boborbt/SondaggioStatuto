class AddValidatedUserFieldToAnswers < ActiveRecord::Migration
  def self.up
    add_column :answers, :validated_user, :boolean
  end

  def self.down
    remove_column :answers, :validated_user
  end
end