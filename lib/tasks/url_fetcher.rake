

namespace :url_fetcher do
  desc "Fetch Libguides Urls"
  task :libguides => :environment do
    
    lb = LibGuides.new
    
    puts "Fetching Tags"
    tags = lb.fetch_all_tags    
    if tags != nil
      puts "Found #{tags.size} tags"
    
      puts "Fetching Links for #{tags.size} tags"
    
      links = lb.fetch_tagged_urls(tags)
      if links != nil
        puts "Retrieved #{links.size} links for #{tags.size} tags"
        puts "Truncating libguides from Tagged URL table"
        TaggedUrl.delete_all_libguides  
        puts "Inserting into the database #{links.size} links, ignoring duplicates"
        saved = lb.insert_tagged_urls(links)
        puts "Saved #{saved} links of #{links.size}."
      else
        puts "Timed Out. See log file for details"
      end
    else
      puts "Timed Out. See log file for details"
    end
    
  end
  
  # task :wordpress => :environment do
  #   wp = WordpressTags.new
  #   
  #   puts "Fetching Tags"
  #   tags = wp.fetch_all_tags    
  #   puts "Found #{tags.size} tags"
  # 
  #   puts "Fetching Links for #{tags.size} tags"
  # 
  #   links = wp.fetch_all_links(tags)
  # 
  #   puts "Retrieved #{links.size} links for #{tags.size} tags"
  # 
  #   puts "Inserting into the database #{links.size} links, ignoring duplicates"
  #   saved = wp.insert_tagged_urls(links)
  #   puts "Saved #{saved} links of #{links.size}."
  #   
  # end
    
end
