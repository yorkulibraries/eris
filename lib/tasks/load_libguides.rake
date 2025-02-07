namespace :load_libguides do
  desc "Load libguides URLs and TAGS from CSV file"
  task :load_csv => :environment do
    TaggedUrl.delete_all_libguides

    filename = "/tmp/libguides.csv"

    require 'csv'
    CSV.foreach(filename, :headers => true) do |row|
      url = TaggedUrl.new
      url.url = row[0]
      url.title = row[1]
      url.tag = row[2]
      url.source = "libguides"
      url.save
    end

  end
end
