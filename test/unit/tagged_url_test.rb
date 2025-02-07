require 'test_helper'

class TaggedUrlTest < ActiveSupport::TestCase

  should "create proper tag url" do
    tu = build(:tagged_url)
    
    assert tu.valid?
    
    assert_difference "TaggedUrl.count", 1 do
      tu.save
    end
    
  end
  
  
  should "not create an invalid tagged url" do
    tu = build(:tagged_url, :title => nil)
    
    assert !tu.valid?
  
    tu = build(:tagged_url, :url => "happy")
    
    assert !tu.valid? , "Invalid URLs should not be passed"
  end
  
  should "insert only unique urls, based on tag and url" do
    first = build(:tagged_url, :title => "whatever", :tag => "tag", :url => "http://www.google.com")
    second = build(:tagged_url, :title => "whatever", :tag => "tag", :url => "http://www.google2.com")
    first_same = build(:tagged_url, :title => "whatever", :tag => "tag", :url => "http://www.google.com") 
    
    
    assert_difference "TaggedUrl.count", 2 do
      first.save
      second.save
    end
    
    assert_no_difference "TaggedUrl.count" do
      first_same.save
    end
    
  end
  
  should "delete all with source libguides" do
            
      create_list(:tagged_url, 3, :source => "libguides")
      fourth = create(:tagged_url, :title => "guide4", :tag => "tag", :url => "http://www.google4.com", :source => "wordpress")
                  
      assert_difference "TaggedUrl.count", -3 do
        TaggedUrl.delete_all_libguides
      end
      
  end  
  
end
