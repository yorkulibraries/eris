class TaggedUrl < ActiveRecord::Base
  attr_accessible :tag, :url, :title, :desc, :source
  paginates_per 50
  
  validates_presence_of :title, :tag, :url, :source
  validates_format_of :url, :with => URI::regexp(%w(http https))
  validates_uniqueness_of :url, :scope => :tag
  
  def self.delete_all_libguides 
    TaggedUrl.destroy_all(:source => "libguides")
  end
      
end
