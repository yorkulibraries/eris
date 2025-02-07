class RemoveHtmlFromServices < ActiveRecord::Migration
  def up
    remove_column :services, :html
  end

  def down
    add_column :services, :html, :text
  end
end
