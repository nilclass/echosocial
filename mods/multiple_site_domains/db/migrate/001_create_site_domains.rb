class CreateSiteDomains < ActiveRecord::Migration
  def self.up
    create_table :site_domains do |t|
      t.string :domain
      t.belongs_to :site

      t.timestamps
    end

    add_index :site_domains, :domain
  end

  def self.down
    drop_table :site_domains
  end
end
