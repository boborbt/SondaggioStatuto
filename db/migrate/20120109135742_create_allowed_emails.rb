class CreateAllowedEmails < ActiveRecord::Migration
  def self.up
    create_table :allowed_emails do |t|
      t.text :email
    end
    
    add_index :allowed_emails, :email
  end

  def self.down
    drop_table :allowed_emails
  end
end
