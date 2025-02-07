require 'test_helper'
require "lib/lib_guides"

class LibGuidesTest < ActiveSupport::TestCase

  should "fetch all tags" do
    libguides = LibGuides.new
    #http://api.libguides.com/api_tags.php?iid=1669&tagformat=br
    
    
    tags = libguides.fetch_all_tags
    assert tags.size > 0
    assert_no_match /(<\/a>)/, tags.first, "Should not contain </a> tag"

    #puts "Tags Fetched: "    
    #puts tags.size
  end
  
  should "return nil on timeout" do
    
    # http://api.libguides.com/api_tags.php?iid=1669&tagformat=br
    # url = 'http://merlin.library.yorku.ca/timeout.php'
    url = "http://www.google.com"
    libguides = LibGuides.new
    
    tags = libguides.fetch_response_from_url(url, 0)
    assert_equal tags, nil
    
  end

  should "fetch tagged urls give a set of tags" do
    # tags = %w(aesthetics s:gs/psyc art)
    tags = %w(aesthetics)
    libguides = LibGuides.new
    
    links = libguides.fetch_tagged_urls(tags)
    
    assert links.size > 0
      
    #puts "Links Fetched: "
    #puts links.size

    # Make sure View More Results is not links list.
    tags = %w(aesthetics)      
    links = libguides.fetch_tagged_urls(tags)
    assert links.size > 0
    
    links.each do |link|
      assert_not_equal "<i>View more results...</i>", link.last
    end
    

  end
  
  should "add tagged urls to the table. Unique only" do
    # get the links, the loop through links, check if unique, add to table
    # check if link unique based on tag and url
    
    libguides = LibGuides.new
    
    links = Array.new
    5.times do |n|
      links << ["http://www.#{n}.com", "title#{n}", "tag#{n}"]
    end
    
    assert_equal 5,  libguides.insert_tagged_urls(links)
  
    assert_equal 0, libguides.insert_tagged_urls(links), "Trying to save duplicates"      
    
  end      
end