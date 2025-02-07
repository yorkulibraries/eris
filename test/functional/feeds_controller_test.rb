require 'test_helper'

class FeedsControllerTest < ActionController::TestCase
 
  should "list all the feeds" do
      create_list(:feed, 10)

      get :index

      assert_response :success
      assert_template "index"

      feeds = assigns(:feeds)

      assert feeds
      assert_equal 10, feeds.count
  end
  
  should "show edit page and update as neccessary" do
    feed = create(:feed, :name => "name")
    
    get :edit, :id => feed.id
            
    assert_response :success
    assert_template :edit
    
    feed.name = "new-name"
    
    put :update, :id => feed.id, :feed => { :name => feed.name, :url => feed.url }
    
    assert_redirected_to feeds_path
    
  end
  
  should "show new page and create a new feed" do
    get :new 
    
    assert_response :success
    assert_template :new
    
    feed = build(:feed, :name => "feed")
    
    assert_difference "Feed.count", 1 do
      put :create, :feed => { :name => feed.name, :url => feed.url }
    end
    
    assert_redirected_to feeds_path
    
  end
  
  should "Save Feed Description" do
    
    assert_difference "Feed.count", 1 do 
      post :create, :feed => { :name => "test", :url => "http://www.test.url", :description => "test", :cache_frequency => 30 }
      @feed = assigns(:feed)
    end
    
    assert_equal "test", @feed.description
  end
  
  should "save show title option" do 
    assert_difference "Feed.count", 1 do
      post :create, :feed => { :name => "test", :show_title => true }
      @feed = assigns(:feed)
    end
    
    assert @feed.show_title
  end
  
end
