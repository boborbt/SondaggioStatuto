class CreateAllowedDomains < ActiveRecord::Migration
  def self.up
    create_table :allowed_domains do |t|
      t.string :domain
      
      t.timestamps
    end
    
    add_index :allowed_domains, :domain
  end

  def self.down
    remove_index :allowed_domains, :domain
    drop_table :allowed_domains
  end
end