class Feed < ActiveRecord::Base
  attr_accessible :name, :url, :cache_frequency, :description, :show_title
  alias_attribute :title, :name
  alias_attribute :feed_url, :url
  
  validates_presence_of :name
  validates_format_of :url, :with => URI::regexp(%w(http https)), :allow_blank => true
  validates_uniqueness_of :name
  
  
  def entries
    @entries == nil ? Array.new : @entries    
  end
  
  def entries=(entries)
    @entries = entries 
  end
  
  
  def append_query_string(query_string)
    return url if query_string.blank? || url.blank?
    
    sign = url.include?('?') ? '&' : '?'
    "#{self.url}#{sign}#{query_string}"
  end
  
  
  def fetch(query_string = nil, feed_title = nil)
    return self if url.blank?
           
    require 'feedzirra'
    require 'open-uri'
    
    feed_url = append_query_string(query_string)
    
    begin
      raw_feed = open(feed_url) { |f| f.read }
      parsed_feed = Feedzirra::Feed.parse(raw_feed)
      self.entries = parsed_feed.entries
    rescue => e
      # error happend, tell it through a feed
      logger.error "#{e.message} for url #{feed_url} and #{title}"
      logger.error "ERROR - TIME: #{Time.now}\n"                  
      self.name = "ERIS - Error Notification"  
      self.description = "An error has occured in #{title} feed. \n\n #{feed_url} \n\n #{e.message} "
      self.entries = nil  
    end   
    
    self   
  end
end
