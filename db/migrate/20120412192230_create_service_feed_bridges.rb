class CreateServiceFeedBridges < ActiveRecord::Migration
  def change
    create_table :service_feed_bridges do |t|
      t.references :service
      t.references :feed
      t.integer :position

      t.timestamps
    end
    add_index :service_feed_bridges, :service_id
    add_index :service_feed_bridges, :feed_id
  end
end
