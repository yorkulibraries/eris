class AddAndRemoveFieldsFromService < ActiveRecord::Migration
  def up
    
    change_table :services do |t|      
      
      t.rename :cache_store, :html
      t.rename :feed_url, :service_slug
            
      t.boolean :transform_course_code, :default => false
      t.boolean :live, :default => false            
    end 
            
  end

  def down
    
    change_table :services do |t|      
      # keep everything as it is now      
    end 
    
  end
end
