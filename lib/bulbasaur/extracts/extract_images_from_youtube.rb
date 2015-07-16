module Bulbasaur

  class ExtractImagesFromYoutube
  
    EXTRACT_URL_PATTERN = /www\.youtube(?:-nocookie)?\.com\/(?:v|embed)\/([a-zA-Z0-9-]+)/i
    EXTRACT_VID_PATTERN = /(?:v|embed)\/(?<vid>[a-zA-Z0-9-]+)/i

    def initialize(html)
      @html = html
    end

    def call
      images = Array.new
      @html.scan(EXTRACT_URL_PATTERN).each do |video|
        vid = get_vid(video)
        url_image = image_url_for(vid)
        images << { url: url_image }
      end
      images
    end

    private

    def get_vid(video)
      EXTRACT_VID_PATTERN.match(video)[:vid]
    end

    def image_url_for(vid)
      "http://img.youtube.com/vi/#{vid}/0.jpg"
    end
  end
end
