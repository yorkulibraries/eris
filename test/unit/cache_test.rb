require 'test_helper'

class CacheTest < ActiveSupport::TestCase
  should "save a valid cache" do
    cache = build(:cache)
    
    assert cache.valid?
    
    assert_difference "Cache.count", 1 do
      cache.save 
    end
  end
  
  should "not save an invalid cache" do
    cache = build(:cache, :url => nil) 
    
    assert !cache.valid?, "Url is not present, so I should fail"
    
    assert_no_difference "Cache.count", "Cache should not be saved" do
      cache.save
    end
    
    
    cache2 = build(:cache, :store => nil)
    assert cache2.store == nil
    assert cache2.store.blank?
    assert !cache2.valid?, "Store is not present, so I should fail, #{cache2.valid?}"
    
    assert_no_difference "Cache.count" do
      cache2.save
    end
        
  end
  
  should "set last_cached_time when creating or updating - should only be done thorugh cache data method" do
    cache_url = "url_to_cache"
    assert_difference "Cache.count", 1 do
      Cache.cache_data(cache_url, "some_data")
    end
    
    cache = Cache.find_by_url(cache_url)
  
    assert_not_nil cache.last_cached, "Last Cached should be set"
    assert cache.last_cached < Time.now, "last cached should set to a date"
    
    # save again with new data, last_cached should be updated
    previous_last_cached = cache.last_cached
    Cache.cache_data(cache_url, "something new")
    
    cache.reload
    assert cache.last_cached > previous_last_cached, "Last cached current must be a new one and note the last time it was cached"
          
  end
  

  should "get cached data, cache not expired, or nil if expired" do
    c = create(:cache, :last_cached => (Time.now - 30.minutes), :store => "cache", :url => "url")
        
    # get not expired cache
    
    data = Cache.get_cached_version("url", 50);
    
    assert_equal "cache", data, "Testing non-expired cache"
    
    # expire cache, should return nil
    create(:cache, :last_cached => 30.minutes.ago, :store => "cache2", :url => "url2")
    
    data = Cache.get_cached_version("url2", 10); 
    
    assert_equal nil, data, "Testing expired cache"
    
  end
  
  should "cache data" do 
    data = "cache"
    url = "url"
    
    Cache.cache_data(url, data)
    
    cache = Cache.find_by_url(url)
    assert_not_nil cache
    assert_not_nil cache.last_cached
    assert Time.now > cache.last_cached
    
  end  
    

end
