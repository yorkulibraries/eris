namespace :libguides do
  desc "Load libguides URLs and TAGS"
  task :load => :environment do
    require 'net/http'
    require 'json'

    site_id = ENV['site_id']
    key = ENV['key'] 

    api = "https://lgapi-ca.libapps.com/1.1/guides/?site_id=#{site_id}&key=#{key}&expand=tags"
    result = Net::HTTP.get(URI(api))

    TaggedUrl.delete_all_libguides

    json = JSON.parse(result)
    json.each do |o|
      url = o['friendly_url'].to_s.empty? ? o['url'] : o['friendly_url']
      if o['tags']
        o['tags'].each do |t|
          if t['text'] =~ /\A[cs]:/i
            tu = TaggedUrl.new
            tu.title = o['name']
            tu.url = url
            tu.tag = t['text']
            tu.source = "libguides"
            tu.save
          end
        end
      end
    end
  end
end
