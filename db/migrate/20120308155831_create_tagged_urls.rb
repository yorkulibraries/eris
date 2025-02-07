class CreateTaggedUrls < ActiveRecord::Migration
  def self.up
    create_table :tagged_urls do |t|
      t.string :tag
      t.string :url
      t.string :title
      t.text :desc
      t.string :source
      t.timestamps
    end
  end

  def self.down
    drop_table :tagged_urls
  end
end
