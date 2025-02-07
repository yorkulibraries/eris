FactoryGirl.define do
   
   sequence :name do |n|
     "service#{n}"
   end
  
   sequence :url do |n|
     "http://url#{n}.com/feed"
   end
   
   sequence :slug do |n|
     "slug#{n}"
   end
   
  factory :service do
    name
    service_slug { FactoryGirl.generate(:slug) }        
    css_style ".eris_feed { color: black; }"
    live true
    transform_course_code false
  end
  
  factory :feed do
    name { FactoryGirl.generate(:slug) }
    url
    description "woot"
    show_title true
  end
  
  factory :tagged_url do 
    sequence(:tag) { |n| "AK/CHEM#{n}" }
    url 
    sequence(:title) { |n| "title of sorts #{n}"}
    desc "WOOT WOOT WOOT"
    source "libguides"
  end
  
  factory :cache do 
    url { FactoryGirl.generate(:url) }
    frequency 30
    last_cached Time.now.utc
    store "Some Cache of Sorts"
  end
  
end