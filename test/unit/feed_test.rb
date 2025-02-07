require 'test_helper'

class FeedTest < ActiveSupport::TestCase

  should "create a valid feed" do
    feed = build(:feed)

    assert feed.valid?

    assert_difference "Feed.count", 1 do
      feed.save
    end
  end

  should "fail if feed is missing attributes" do
    feed = build(:feed, :name => nil)

    assert !feed.valid?, "Feed should not be valid, but was"

    assert_no_difference "Feed.count" do
      feed.save
    end


    create(:feed, :name => "name")
    feed.name = "name"

    assert !feed.valid?, "Should not save feeds with unique names."


    assert_no_difference "Feed.count" do
      feed.save
    end
  end

  should "update feed, should pass on valid and fail on invalid" do
    feed = create(:feed, :name => "update")

    feed.name = "new-name"
    assert feed.valid?

    assert_no_difference "Feed.count" do
      feed.save
    end


    create(:feed, :name => "dup")
    feed.name = "dup"

    assert !feed.valid?, "Should not be valid, since name is duplicate"

  end

  should "store and retrieve entries" do
    entries = Array.new
    entries << "1"

    feed = Feed.new

    feed.entries = entries

    assert_not_nil = feed.entries
    assert_equal "1", feed.entries.first

    feed.entries = nil

    assert_not_nil = feed.entries
    assert_equal 0, feed.entries.size

  end


  should "be able to fetch the feed and return the Feed as an object" do
    feed = create(:feed, :name => "test", :url => "https://www.library.yorku.ca/subjects/advertising/feed.atom")

    data = feed.fetch
    assert data != nil
    assert data.title != nil

  end

  should "return an error feed, if the feed is invalid or not there" do
    feed = create(:feed)

    data = feed.fetch

    assert_equal "ERIS - Error Notification", data.title

  end

  should "append the query string propery to a url, even if url already has a query string" do
    feed = Feed.new
    feed.url = url =  "http://www.test.com"
    query_string = "woot=test"

    assert_equal "#{url}", feed.append_query_string(nil), "Return the url if query string is nil or blank"

    assert_equal "#{url}?#{query_string}", feed.append_query_string(query_string), "Should append ? and the query string"

    feed.url = url = "http://www.test.com?something_else=woot"

    assert_equal "#{url}&#{query_string}", feed.append_query_string(query_string), "Should append & and query string"

  end

  should "cache the feed, first time it gets it" do
    feed = create(:feed, :name => "test", :url => "https://www.library.yorku.ca/subjects/advertising/feed.atom", :cache_frequency => 10)

    assert_difference "Cache.count", 1 do
      data = feed.fetch
      assert_not_nil data
    end

    # now hit it again, it should say cached

    data = feed.fetch
    assert_not_nil data

    assert_equal "cached", data.feed_url, "Feed Url will have cached attribute in instead of the feed url URL: #{data.url}"


  end

  should "Not fetch if url is empty" do
    feed = create(:feed, :name => "test", :url => nil, :cache_frequency => 10)

    data = feed.fetch
    assert_equal 0, data.entries.size

  end

  should "be able to save and update html description" do
    feed = create(:feed, :name => "test", :description => "test")

    assert_equal "test", feed.description

    feed = build(:feed, :description => "test2")

    feed.save
    feed.reload

    assert_equal "test2", feed.description

  end

  should "be able to set show title option" do
    feed = create(:feed, :name => "test", :show_title => true)

    assert feed.show_title

    feed = build(:feed, :show_title => false)
    feed.save
    feed.reload

    assert !feed.show_title
  end

end
