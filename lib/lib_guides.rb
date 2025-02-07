# load Rails ENV so that we can save stuff to Database
# require "#{File.dirname(__FILE__)}/../../config/environment.rb"

require 'uri'
require 'net/http'

class LibGuides
  
  def fetch_response_from_url(url, timeout = 60)
    # set timeout
    # fetch url
    # return response if good
    # nil if timeout
    response = ""
    uri = URI.parse(url)

    begin
      Net::HTTP.start(uri.host, uri.port) do |http|
        http.open_timeout = timeout
        http.read_timeout = timeout
        request = Net::HTTP::Get.new uri.request_uri

        response = http.request request # Net::HTTPResponse object
      end

    return response
    
    rescue Timeout::Error => e
      message = "ERROR - #{url} - #{e}, waited #{timeout} seconds"
      Rails.logger.fatal "#{message}"
      return nil
    end
    
  end


   def fetch_all_tags

     tags = Array.new
     
     url = "http://api.libguides.com/api_tags.php?iid=1669&tagformat=br"
     
     # r = Net::HTTP.get_response(URI.parse(url))
     r = fetch_response_from_url(url)

     if r != nil
       r.body.each_line("<br>") do |line|
         tag = line.scan(/.+>(.+)<\//)
         tags << tag.first.first
       end
     else
       return nil
     end     
    tags
     
   end
   
   def fetch_tagged_urls(tags)

     links = Array.new
     
     
     tags.each do |tag|
       url = "http://api.libguides.com/api_search.php?iid=1669&search=#{URI.encode(tag)}&type=tags"

       # r = Net::HTTP.get_response(URI.parse(url))
       r = fetch_response_from_url(url)
       if r != nil
         r.body.each_line("<BR>") do |line|
           link = line.scan(/<a href="([^"]+)" target="_blank">(.+)<\/a>.*/)
                
           if link.size > 0
             link = link.first           
             link << tag
             links << link unless link[1] == "<i>View more results...</i>"
           end
         end         
       else
         return nil   
       end
     end
     
     links
     
   end
   
   
   def insert_tagged_urls(links)
     saved = 0
     
     links.each do |link|
       url = TaggedUrl.new
       
       url.url = link[0]
       url.title = link[1]
       url.tag = link[2]

       url.source = "libguides"
       
       saved = saved + 1 if url.save
     end
     #puts "Fetched and saved #{saved} urls"
     saved 
   end
   
   # def do_work
   # 
   #   saved = insert_tagged_urls(fetch_tagged_urls(fetch_all_tags()))
   #   
   #   puts "Fetched and saved #{saved} urls"
   # end
end

