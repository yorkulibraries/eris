class Cache < ActiveRecord::Base
  
  validates_presence_of :url, :store
  
  
  
  def Cache.get_cached_version(url, limit)
    limit = 0 if limit == nil
      
    c = Cache.find_by_url(url);    
            
    if c == nil || c.store == nil || Time.now.utc > (c.last_cached + limit.minutes)
      nil 
    else
      c.store
    end        
  end  
  
  def Cache.cache_data(url, data)
    c = Cache.find_by_url(url) || Cache.new
    
    c.url = url
    c.store = data
    c.last_cached = Time.now.utc
    
    c.save
  end
  
end
