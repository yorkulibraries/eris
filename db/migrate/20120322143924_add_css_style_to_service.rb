class AddCssStyleToService < ActiveRecord::Migration
  def change
    add_column :services, :css_style, :text

  end
end
