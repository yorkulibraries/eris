# load Rails ENV so that we can save stuff to Database
# require "#{File.dirname(__FILE__)}/../../config/environment.rb"

require 'uri'
require 'net/http'
require 'nokogiri'
require 'open-uri'



# FEED EXAMPLE URL 
# http://www-dev.library.yorku.ca/cms/blog/tag/ali-test/feed
# ServerURL/cms/site-name/tag/tagname1,tagname2.../feed

class WordpressTags    
  
  def get_urls
    counter = 1
    sites = Array.new 
    # sites << "http://www-dev.library.yorku.ca/cms/list-of-all-tags/"    
    begin

      file = File.new("lib/wordpress_sites.txt", "r")
      while (line = file.gets)
          # puts "#{counter}: #{line}"
          line.chomp
          sites << "#{line}"
          counter = counter + 1
      end
      file.close

    rescue => err
      puts "Exception: #{err}"
      err

    end
    
    sites
  end
  
  def fetch_all_tags(url = nil)
    
    tags = Array.new
    site_urls = Array.new
    
    #Fetch Sites 
    site_urls = get_urls()
    
    # For each site, extract the tags and their feed urls
    site_urls.each do |url|
    
      if(url)
        
        # Sample URL
        # url = "http://www-dev.library.yorku.ca/cms/list-of-all-tags/"
        
        response = Net::HTTP.get_response(URI(url)).class.name

        if (response == "Net::HTTPNotFound")
          #puts "RESPONSE #{response}, SKIPPED #{url}"          
          # DO NOTHING
          
        else
          
          doc = Nokogiri::HTML(open(url))

          doc.xpath('//span[@class="mytag"]//a[@href]').each do |tag|

              tags <<  [tag.content, tag['href']]
          end
        end # if response
      end # if url
    end # site_urls
    tags
    
    
  end
  
  def fetch_all_links(tags)
   # require 'app/models/service'

    links = Array.new    
    
    if(tags && tags.kind_of?(Array))    
      tags.each do |tag|    
         # source = "http://www-dev.library.yorku.ca/cms/blog/tag/#{URI.encode(tag.first)}/feed"
         source = "#{URI.encode(tag.second)}feed"
         feed_service = Feed.new(:name => 'wordpress', :url => source)
         feed = feed_service.fetch()
         feed.entries.each do |entry|
           links << [entry.title, entry.url, entry.summary, tag.first] if entry.title != "We've encountered an error"
         end
       
      end
    end

    links
  end
  
  def insert_tagged_urls(links)
    saved = 0
    if(links.kind_of?(Array))
      links.each do |link|
        
        url = TaggedUrl.new

        url.title = link[0]
        url.url = link[1]
        url.desc = link[2]
        url.tag = link[3]

        url.source = "wordpress"
      
        saved = saved + 1 if url.save
      end  
    end
    # puts "Fetched and saved #{saved} urls"    
    saved 
  
  end
  
  
  
end
