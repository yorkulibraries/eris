xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
 xml.channel do

   xml.title       @service.name
   xml.link        fetch_url(@service.service_slug)
   xml.description "Eris Service Feed"

   @feeds.each do |feed|
     unless feed.description.blank?
       xml.item do
         xml.title = feed.title
         xml.link = feed.url
         xml.description = feed.description
         xml.guid = feed.url
       end
     end
     feed.entries.each do |entry|
       xml.item do
         xml.title       entry.title
         xml.link        "#{redirect_url}/?#{@query_string}&url=#{u entry.url}"
         xml.description feed.title
         xml.guid        entry.url
       end

     end
   end

 end
end
