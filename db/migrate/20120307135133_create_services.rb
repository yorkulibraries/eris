class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services do |t|
      t.string :name
      t.string :feed_url
      t.integer :cache_frequency
      t.text :cache_store
      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end
