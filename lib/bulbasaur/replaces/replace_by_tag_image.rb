module Bulbasaur

  class ReplaceByTagImage 

    def initialize(html, image_replaces = [])
      @html = html
      @image_replaces = image_replaces
    end

    def call
      nokogiri = Nokogiri::HTML::DocumentFragment.parse(@html)
      nokogiri.css('img').each do |item|
        url = item.xpath("@src").text
        replace = @image_replaces.select{ |r| r[:original_image_url] == url }.first
        item.set_attribute("src", replace[:url]) unless replace.nil?
      end
      nokogiri.to_s
    end

  end
end
