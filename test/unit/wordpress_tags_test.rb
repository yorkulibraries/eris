require 'test_helper'
require "lib/wordpress_tags"

class WordpressTagsTest < ActiveSupport::TestCase
  
  ### ALL TESTS COMMENTED OUT DUE TO INUSE. PAGES DON'T EXISTS ###
 
  # should "fetch all wordpress tags" do
  #   
  #   wordpress_tags = WordpressTags.new
  #   url = "http://www-dev.library.yorku.ca/cms/list-of-all-tags/"
  #   
  #   tags = wordpress_tags.fetch_all_tags(url)
  #   assert tags
  #   assert tags.size > 0, "Should have more than 1"
  #   
  #   tags.each do |tag|
  #     assert_no_match /(<\/span>)/, tag.first, "Should not contain </span> tag"
  #     assert_no_match /(<\/a>)/, tag.first, "Should not contain </a> tag"
  #     assert_match /(http:\/\/)/, tag.second, "Should contain http:// tag"
  #   end
  #   
  # end
  # 
  # should "skip blank or not found tags" do
  #   wordpress_tags = WordpressTags.new
  #   tags = [
  #           ["ali-test", "http://www-dev.library.yorku.ca/cms/blog/tag/ali-test/"], 
  #           ["ali2", "http://www-dev.library.yorku.ca/cms/blog/tag/ali2/"],
  #           ["foo", "http://www-dev.library.yorku.ca/cms/blog/tag/foo/"]
  #          ]
  #   links = wordpress_tags.fetch_all_links(tags)
  #   assert links
  #   assert links.kind_of?(Array), "is not an array"
  #   
  #   links.each do |link|
  #     assert_not_equal nil, link, "link should not be blank"
  #     assert link.kind_of?(Array) && link.size > 2, "Should be array and have at least title and link"
  #     assert_not_equal "We've encountered an error", link.first, "Should not have 'encountered an error'"
  #   end
  #   
  #   
  # end
  # 
  # should "fetch pages for specific tag" do
  #   wordpress_tags = WordpressTags.new
  #   tags = [
  #           ["ali-test", "http://www-dev.library.yorku.ca/cms/blog/tag/ali-test/"], 
  #           ["ali2", "http://www-dev.library.yorku.ca/cms/blog/tag/ali2/"],
  #           ["foo", "http://www-dev.library.yorku.ca/cms/blog/tag/foo/"]
  #          ]
  #          
  #   links = wordpress_tags.fetch_all_links(tags)
  #   assert links.kind_of?(Array), "should be an array"
  #   #assert links.size > 0, "There should be at least one link"
  # 
  #   
  #   links.each do |link|
  #     assert_not_equal nil, link, "link should not be blank"
  #     assert link.kind_of?(Array), "should be an array"
  #     assert link.size > 1, "Should be array and have at least title and link"
  #   end
  #   
  # end
  # 
  # should "have title, link, description, tag and be unique on url" do
  #   wordpress_tags = WordpressTags.new
  #   
  #   links = Array.new
  #   5.times do |n|
  #     links << ["title#{n}", "http://www.#{n}.com", "description#{n}", "tag#{n}"]
  #   end
  #   
  #   assert_equal 5,  wordpress_tags.insert_tagged_urls(links)
  # 
  #   assert_equal 0, wordpress_tags.insert_tagged_urls(links), "Trying to save duplicates"
  #   
  # end
  # 
  # should "open a file for reading" do
  #   counter = 1
  #   
  #   file = File.new("lib/wordpress_sites.txt", "r")
  #   
  #   assert file, "Error with file"
  #   
  #   while (line = file.gets)
  #       assert_not_equal nil, line, "line is nil" 
  #       counter = counter + 1
  #   end
  #   file.close
  # end
  # 
  # should "open a file and read into array" do
  #   
  #   counter = 1
  #   sites = Array.new
  #   file = File.new("lib/wordpress_sites.txt", "r")
  #   
  #   assert file, "Error with file"
  #   
  #   while (line = file.gets)
  #       line.chomp("\n")
  #       sites << "#{line}"
  #       counter = counter + 1
  #   end
  #   file.close
  #   
  #   assert sites.size > 0, "Sites more than 1. Otherwise file may be empty" 
  #   
  # end
  # 
  # should "skip NOT FOUND urls" do
  #   wordpress_tags = WordpressTags.new
  #   sites = Array.new
  #   
  #   sites = wordpress_tags.get_urls
  #   # url = "http://www-dev.library.yorku.ca/cms/list-of-all-tags2/"
  # 
  #   sites.each do |url|
  #     response = Net::HTTP.get_response(URI(url)).class.name
  #     
  #     if (response == "Net::HTTPNotFound")
  # 
  #     else
  #       doc = Nokogiri::HTML(open(url))
  #       doc.xpath('//span[@class="mytag"]//a[@href]').each do |tag|
  # 
  #       end
  # 
  #     end    
  #   end
  # end
  # 
  # should "do all from array or file and call other tasks" do
  #   wordpress_tags = WordpressTags.new
  #   sites = Array.new
  #   
  #   site_count = 0
  #   tag_count = 0
  #   links_saved = 0
  #   
  #   sites = wordpress_tags.get_urls
  #       
  #   assert sites.kind_of?(Array), "Is sites an array of sites?"
  #   
  #   sites.each do |url|
  #     tags = wordpress_tags.fetch_all_tags(url)
  #     assert tags
  #     assert tags.size > 0, "Should have more than 1"
  #   
  #     tags.each do |tag|
  #       assert_no_match /(<\/span>)/, tag.first, "Should not contain </span> tag"
  #       assert_no_match /(<\/a>)/, tag.first, "Should not contain </a> tag"
  #       assert_match /(http:\/\/)/, tag.second, "Should contain http:// tag"
  #       tag_count = tag_count + 1
  #     end
  #     
  #     links = wordpress_tags.fetch_all_links(tags)
  #     assert links.kind_of?(Array), "Should be an array"
  #     #assert links.size > 0, "is not an array or size is 0"
  # 
  # 
  #     links.each do |link|
  #       assert_not_equal nil, link, "link should not be blank"
  #       assert link.kind_of?(Array), "Should be an array"
  #       assert link.size > 1, "Should be array and have at least title and link"
  #       
  #     end
  #     
  #     saved = wordpress_tags.insert_tagged_urls(links)
  #     
  #   end
  # 
  # end
  # 
  
end