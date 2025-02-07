class AddMaxEntriesFieldToServices < ActiveRecord::Migration
  def change
    add_column :services, :show_max_entries, :integer, :default => 5
  end
end
