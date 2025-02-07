class ServiceFeedBridge < ActiveRecord::Base
  belongs_to :service
  belongs_to :feed
  
  #default_scope order("position")
end
