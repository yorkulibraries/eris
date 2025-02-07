require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  
  should "list all of the services on the screen" do
    create_list(:service, 20)
    
    get :index
    
    assert_response :success
    assert_template "index"
    
    services = assigns(:services)
    
    assert services
    assert_equal 20, services.count    
  end
     
     
  should "fetch RSS Feed and parse it" do
    s = create(:service, :name => "test service", :service_slug => "slug")
    feed = create(:feed)
    s.feed_ids = feed.id
    s.save
    
    assert_generates "/fetch/slug", { :controller => "services", :action => "fetch", :slug => "slug" } 
    get "fetch", :slug => "slug"
    
    assert_response :success

    
    assert assigns(:service) 
    assert assigns(:feeds)   
    assert_not_nil assigns(:feeds)
    
    assert_template :fetch
  end
  
  
  
  should "show edit form and a list of feeds to be added to it " do
    s = create(:service)
    create_list(:feed, 5)
    
    get :edit, :id => s.id
    
    assert_template :edit
    
    # ensure that it has a list of feeds, should be 5
    assert_select "form input" do
      assert_select "[id=?]", /service_feed_ids.+/, 5  # Not empty
    end 
    
  end
  
  should "be able to create a new service" do
    s = build(:service)
    
    get :new
    
    assert_response :success
    assert_template :new
    
    assert_difference "Service.count", 1 do
      put :create, :service => { :name => s.name, :service_slug => s.service_slug, :css_style => s.css_style, :live => true, :transform_course_code => false }
    end
    
    
    assert_response :redirect
    s = assigns(:service)
    assert_redirected_to service_path(s.id)
        
  end
  
  should "save service_feed_bridge after the boxes are checked off and remove them if they are unchecked" do
    s = create(:service)
    create_list(:feed, 2)
    
    assert_difference "ServiceFeedBridge.count", 2 do
      put :update, :id => s.id, :service => { :feed_ids => [1,2] }
    end

    assert_difference "ServiceFeedBridge.count", -2 do
      put :update, :id => s.id, :service => { :feed_ids => nil }
    end
  end
  
  should "show the details of the service and a list of feeds it is part of" do
    s = create(:service)
    feeds = create_list(:feed, 2)
    
    s.feed_ids = [feeds.first.id, feeds.last.id]
    s.save
    
    get :show, :id => s.id
    
    assert_response :success
    assert_template :show
    
    service = assigns(:service)
    
    assert service

    assert_select "ul#feeds" do
      assert_select "li", 2  
    end

    
  end

  
  should "display a live service, and not display a suspended service" do
    s = create(:service, :name => "live")
    
    feeds = create_list(:feed, 2)
    s.feed_ids = [feeds.first.id, feeds.last.id]
    s.live = true
    s.save
    
    get :fetch, :slug => s.service_slug
    
    assert_response :success
    
    assert_select "title", "live service" 
  
  
    s.live = false
    s.save
    
    get :fetch, :slug => s.service_slug
    assert_response :success
    
    assert_select "title", 0
        
  end
  
  should "display a non-live service for preview only" do
    s = create(:service, :name => "not-active", :live => "false")
    
    get :fetch, :slug => s.service_slug, :preview => true
    
    assert_response :success
    assert_select "title", "not-active service"
    
  end
  

  should "return an error if trying to delete a live service" do
    s = create(:service, :live => true)
    
    assert_no_difference "Service.count" do
      delete :destroy, :id => s.id
    end
    
    assert_redirected_to service_path(s.id)
    assert_equal 'The service must be take off line, before you can delete it.', flash[:alert]
    
  end
  
  
  should "sort feeds properly" do
    s = create(:service, :live => true)
    feeds = create_list(:feed, 2)
    s.feed_ids = [feeds.first.id, feeds.last.id]
    s.save
    

    post :sort_feeds, :id => s.id, :feed => [2, 1]
    
    s.reload
    assert_response :success
    
    assert s.feeds.first.id == 2, "first feed should be last "
    assert s.feeds.last.id == 1, "last feed should be first"    
    
  end
  
  
  should "transform course codes into proper tags" do
     s = create(:service, :name => "test service", :service_slug => "slug", :transform_course_code => true)
      feed = create(:feed)
      s.feed_ids = feed.id
      s.save
    
      get "fetch", :slug => "slug", :courses => "2011_GS_PPAL_Y_6100__3_A,2011_SC_NATS_Y_1670__6_A"
      
      assert_response :success
      # assert_equal "PPAL_6100,GS/PPAL,PPAL,NATS_1670,SC/NATS,NATS", @request.parameters[:tag]      
      query_string = assigns(:query_string)
      assert_match "courses=2011_GS_PPAL_Y_6100__3_A,2011_SC_NATS_Y_1670__6_A&tag=PPAL_6100,GS/PPAL,GS/ppal6100,NATS_1670,SC/NATS,SC/nats1670,2011_GS_PPAL_Y_6100__3_A,2011_SC_NATS_Y_1670__6_A",URI.unescape(query_string)
  end

  should "If courses is blank, default to courses=xxxx" do
     s = create(:service, :name => "test service", :service_slug => "slug", transform_course_code: true)
      feed = create(:feed)
      s.feed_ids = feed.id
      s.save
    
      get "fetch", :slug => "slug", courses: ""
                  
      assert_response :success
      # assert_equal "PPAL_6100,GS/PPAL,PPAL,NATS_1670,SC/NATS,NATS", @request.parameters[:tag]      
      query_string = assigns(:query_string)
      ms = "course=XXXX_XX_XXXX_X_XXXX__X_X_XX_X_XXXX_XX&tag=XXXX_XXXX,XX/XXXX,XX/xxxxXXXX,XXXX_XX_XXXX_X_XXXX__X_X_XX_X_XXXX_XX&program_codes=XXXX_XXXX,XX/XXXX,XX/xxxxXXXX"
      assert_match ms,query_string
      
      get "fetch", slug: "slug"
      
      query_string = assigns(:query_string)
      assert_equal ms, query_string
  end
    
  
end
