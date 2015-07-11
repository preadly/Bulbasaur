module Bulbasaur

  class ExtractImagesFromYoutube
  
    EXTRACT_URL_PATTERN = /www\.youtube\.com\/(?:v\/|.+?&v=|embed\/)\w+/i
    EXTRACT_VID_PATTERN = /(?<=v\/|embed\/)(?<vid>\w+)/i

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
