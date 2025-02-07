require 'test_helper'

class TaggedUrlsControllerTest < ActionController::TestCase

  should "List all tagged urls" do
    create_list(:tagged_url, 20)
    
    get :index 
    
    assert_response :success 
    
    urls = assigns(:tagged_urls)
    assert urls 
    assert_equal 20, urls.size
    
  end
  
  should "List Urls as RSS Feed" do
    create_list(:tagged_url, 20)
    create(:tagged_url, :title => "lookforme")
    
    get :index, :format => "rss"
    
    assert_response :success
    assert_select "title", "lookforme"
  end
    
  should "list urls based on params of tag" do
    create_list(:tagged_url, 5)
    create(:tagged_url, :tag => "mytag", :title => "Baba")

    
    get :index, { :tag => "mytag" }
    
    assert_response :success
    urls = assigns(:tagged_urls)
    assert urls
    assert_equal 1, urls.size, "Tags Test"
    assert_equal "mytag", urls.first.tag
  end
  
  should "list urls based on a list of tags, with prefix for course or subject" do
    create(:tagged_url, :tag => "c:sc/comp1000")
    create(:tagged_url, :tag => "s:ak/chem")
    create(:tagged_url, :tag => "not_part_of_this_system")
    
    get :index, {:tag => "COMP_1000,SC/COMP,SC/comp1000", :prefix => "c" }
    
    assert_response :success
    urls = assigns(:tagged_urls) 
    assert urls
    assert_equal 1, urls.size, "Must Return one tagged url"  
    
    
    get :index, {:tag => "CHEM_1010,AK/CHEM,AK/chem1010", :prefix => "s"}
    
    assert_response :success
    urls = assigns(:tagged_urls) 
    assert urls
    assert_equal 1, urls.size, "Must Return one tagged url"  
    
    
  end
  
  should "list urls based on source" do
    create_list(:tagged_url, 3)
    create(:tagged_url, :source => "wordpress123")
    
    get :index, { :source => "wordpress123"}

    assert_response :success
    urls = assigns(:tagged_urls)
    assert urls
    assert_equal 1, urls.size, "Source Test"
    assert_equal "wordpress123", urls.first.source
    
  end
  
  should "get a list of unique tags in db" do
    create_list(:tagged_url, 5)
    create(:tagged_url, :tag => "Ali", :title => "lookforme")
    create(:tagged_url, :tag => "Ali", :title => "lookforme2222")
    create(:tagged_url, :tag => "Ali2", :title => "lookforme33333")
    
    get "tags"
    
    
    assert_template :index
    
    urls = assigns(:tagged_urls)
    assert urls
    assert urls.size == 7, "Did not return proper group by"
    
  end
  
end

