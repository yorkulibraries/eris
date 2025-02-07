xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Eris - Tagged URLs"
    xml.description ""
    xml.link tagged_urls_url

    for url in @tagged_urls
      xml.item do
        xml.title url.title
        xml.description url.desc
        xml.pubDate url.created_at.to_s(:rfc822)
        xml.link url.url
        xml.guid url.url
      end
    end
  end
end
