module Bulbasaur
  
  class ExtractImagesFromHTML
    
    CSS_IMPORT_URL_REGEX = /(?<=url\()['"]?.+?['"]?.+?(?=\))/
    IMG_CANDIDATE_URL_REGEX = /https?:\/\/\S*\.(?:png|jpg|jpeg|gif)[(?:|~\w)]*(?!\.\S)/i

    def initialize(html)
      @html = html
    end

    def call
      images = Array.new
      images = images + extract_images_by_tag_image
      images = images + extract_images_by_tag_style
      images = images + extract_images_by_link
      images
    end

    private

    def extract_images_by_tag_image
      images = Array.new
      Nokogiri::HTML(@html).xpath("//img").each do |item|
        url = item.xpath("@src").text
        alt = item.xpath("@alt").text
        images << create_struct(url, alt)
      end
      images
    end

    def extract_images_by_tag_style
      images = Array.new
      @html.scan(CSS_IMPORT_URL_REGEX).each do |url|
        images << create_struct(url)
      end
      images
    end

    def extract_images_by_link
      images = Array.new
      Nokogiri::HTML(@html).xpath('//a').each do |link|
        url = link.xpath('@href').text
        images << create_struct(url) if url =~ IMG_CANDIDATE_URL_REGEX
      end
      images
    end

    def create_struct(url, alt=nil)
      {url: url, alt: alt } 
    end
  end
end
