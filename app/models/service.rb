class Service < ActiveRecord::Base
  attr_accessible :name, :service_slug, :html, :css_style, :feed_ids, :live, :transform_course_code, :show_max_entries

  attr_accessible :feed_ids

  validates_presence_of :name, :service_slug
  validates_length_of :service_slug, :maximum => 30
  validates_format_of :service_slug, :with => /^[a-z\d_]+$/, :message => "can only be lowercase and alphanumeric with no spaces"
  validates_uniqueness_of :service_slug, :message => "the name must be unique"

  has_many :service_feed_bridges
  has_many :feeds, :through => :service_feed_bridges, :order => "position"

  
  def fetch_feeds(query_string)



    feeds_list = []
    self.feeds.each do |feed|
      f = feed.fetch(query_string, feed.name)

      feeds_list << f unless f.blank?
    end

    feeds_list
  end


  def destroy
    if live
      return
    else
      super
    end
  end

  def self.parse_course_codes(course_list)

    return Array.new if course_list == nil || !course_list.kind_of?(Array)

    courses = Array.new

    course_list.each do |course_code|
      course_parts = course_code.split("_")

      if course_parts.count > 5
        # 2011_GS_PPAL_Y_6100__3_A  - take the 3rd and 5th parts -> PPAL_6100  -- take 2nd and 3rd -> GS/PPAL and -- take 2nd, 3rd and 5th part GS/ppal6100
        courses.push (course_parts[2] + "_" + course_parts[4])
        courses.push (course_parts[1] + "/" + course_parts[2])
        courses.push (course_parts[1] + "/" + course_parts[2].downcase  + course_parts[4])
      end
    end

    return courses
  end



end
