class AddCacheFrequencyToFeedRemoveFromService < ActiveRecord::Migration
  def change    
      add_column :feeds, :cache_frequency, :integer, :default => 30    
  end
end
