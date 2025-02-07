require 'test_helper'

class ServiceTest < ActiveSupport::TestCase

  should "create a new service, valid service" do
    service = build(:service)
        
    assert_difference "Service.count", 1 do
      service.save
    end
    
  end

  should "not allow service_slugs to be longer then 30 chars" do
    service = build(:service)
    
    service.service_slug = 40.times.to_s
    
    assert !service.valid?
    
  end

  should "have name and feed url present before creating it" do
    s = build(:service, :name => nil)
    assert !s.valid?
    s = build(:service, :service_slug => nil)
    assert !s.valid?
    
  end


  should "not create a new service with duplicate slug, and a valid name" do
    create(:service, :service_slug => "service")
    service = build(:service, :service_slug => "service")
    
    assert !service.valid?
    
    assert_no_difference "Service.count" do
      service.save
    end
    
  end

  should "delete not live service" do
    s = create(:service, :live => false)
    
    assert_difference "Service.count", -1 do
      s.destroy
    end    
  end

  should "update service" do
    s = create(:service)
    
    s.name = "updated_name"
    assert s.valid?
    s.save
    
    s.reload
    
    assert_equal "updated_name", s.name
    
  end
  
  
  should "save the css style propely" do
    css_style = ".eris_feed { color: red; }"
    s = build(:service, :css_style => css_style)
    
    assert s.valid?
    s.save
    
    s.reload
    
    assert_equal css_style, s.css_style
    
  end
  
  should "not delete a live service" do
    s = create(:service)
    
    assert_no_difference "Service.count" do
      s.destroy
    end
  end


  should "display feeds in a give order" do
    feeds = create_list(:feed, 4)
    s = create(:service, :feed_ids => [4,3,1,2])
    
    assert s.feeds.first.id == 4, "first feed should be 4" 
    assert s.feeds.last.id == 2, "last feed should be 2"
  end


  should "parse course code" do
    course_list = %w(2011_GS_PPAL_Y_6100__3_A 2011_SC_NATS_Y_1670__6_A)
      
    tags = Service.parse_course_codes(course_list)
    
    assert_equal 6, tags.size
    assert_equal "PPAL_6100", tags[0]
    assert_equal "GS/PPAL", tags[1]    
    assert_equal "GS/ppal6100", tags[2]
    assert_equal "NATS_1670", tags[3]
    assert_equal "SC/NATS", tags[4]
    assert_equal "SC/nats1670", tags[5]
    
    
    
    tags = Service.parse_course_codes(1)
    assert_equal 0, tags.size, "If not array, Array with no elements should be back"
    
  end


end
