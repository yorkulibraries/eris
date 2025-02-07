class CreateCaches < ActiveRecord::Migration
  def change
    create_table :caches do |t|
      t.string :url
      t.integer :frequency
      t.text :store
      t.datetime :last_cached

      t.timestamps
    end
  end
end
