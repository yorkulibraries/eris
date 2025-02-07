require 'test_helper'

class ServiceFetchingTest < ActionDispatch::IntegrationTest

  setup do
    Capybara.default_driver = :selenium
    @service_slug = "service"
    @service = create(:service, name: "test service", service_slug: @service_slug)

    @feed_one_slug = "advertising"
    @feed_one = create(:feed, url: "https://www.library.yorku.ca/subjects/advertising/feed.atom", name: @feed_one_slug )

    @feed_two_slug = "biology"
    @feed_two = create(:feed, url: "https://www.library.yorku.ca/subjects/biology/feed.atom", name: @feed_two_slug ) 

  end

  should "not print anything if there are no feeds to show" do
    visit("/fetch/#{@service_slug}")

     assert_raise(Capybara::ElementNotFound) {
       page.find("#eris-service-#{@service_slug}").visible?
     }
  end

  should "print out eris-service-service-slug first, rather then having it included verbatim" do

    @service.feed_ids = [@feed_one.id]
    @service.save

     visit("/fetch/#{@service_slug}")

     assert find("#eris-service-#{@service_slug}").visible?
  end

  should "fetch rss Feed and load css properly" do

    @service.feed_ids = [@feed_one.id]
    @service.name = "Fetch RSS FEED and load Jquery Properly"
    @service.css_style = "#eris-service-test { color: green; }"
    @service.save


    visit("/fetch/#{@service_slug}")

    assert find("title").has_content?("RSS FEED")

    # only one feed, get the first feed, and see if h2 is there.
    assert page.find("#eris-service-#{@service_slug} .eris-feed-title-#{@feed_one_slug}").visible?, "checking to make sure h3 for the feed is loaded"

    page.all("style").each do |style|
      if style.has_content? "#eris-service-test"
        assert style.has_content?("#eris-service-test"), "Checking to make sure css is loaded."
      end
    end

  end


  should "not fail if css_style is not present" do

    @service.feed_ids = [@feed_one.id]
    @service.name = "test"
    @service.save

    visit("/fetch/#{@service_slug}")

    assert find(".eris-feed-title-#{@feed_one_slug}").has_content?("#{@feed_one_slug}"), "Should not fail here "
    assert !page.has_css?("whatever")  , "Should not fails"
  end


  should "fetch two feeds in one service" do


    @service.name = "Two Feeds"
    @service.feed_ids = [@feed_one.id, @feed_two.id]
    @service.save


     visit("/fetch/#{@service_slug}")

    assert page.find(".eris-feed-title-#{@feed_one_slug}").visible?, "checking to make sure h3 for the feed is loaded"
    assert page.find(".eris-feed-title-#{@feed_two_slug}").visible?, "checking to make sure h3 for the feed is loaded"

  end

  should "fetch two feeds, one with url empty and one without but with description" do

    @feed_one.description = "<h4>woot</h4>"
    @feed_one.url = nil
    @feed_one.save

    @service.feed_ids = [@feed_one.id, @feed_two.id]
    @service.save


    visit("/fetch/#{@service_slug}")

    assert page.find(".eris-feed-title-#{@feed_one_slug}").visible?, "checking to make sure h3 for the feed is loaded"
    assert page.find(".eris-feed-description-#{@feed_one_slug}").find("h4").visible?, "h4 should come from the description"

    assert page.find(".eris-feed-title-#{@feed_two_slug}").visible?, "checking to make sure h3 for the feed is loaded"
  end


  should "show feed title only if show_title is true" do
    service = create(:service, :name => "Two Special Feeds - Description", :service_slug => "show_title_or_not")

    @feed_one.update_attribute(:show_title, true)
    @feed_two.update_attribute(:show_title, false)

    @service.name = "Two Special Feeds - Description"
    @service.feed_ids =  [@feed_one.id, @feed_two.id]

    @service.save


    visit("/fetch/#{@service_slug}")

    assert page.find(".eris-feed-title-#{@feed_one_slug}").visible?, "First Feed's Title should be visible"

    assert_raise(Capybara::ElementNotFound) {
      page.find(".eris-feed-title-#{@feed_two_slug}")
    }

  end

end
