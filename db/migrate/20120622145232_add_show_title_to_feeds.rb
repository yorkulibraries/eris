class AddShowTitleToFeeds < ActiveRecord::Migration
  def change
    add_column :feeds, :show_title, :boolean, :default => true
  end
end
