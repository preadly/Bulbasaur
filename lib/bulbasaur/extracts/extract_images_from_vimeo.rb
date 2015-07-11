module Bulbasaur

  class ExtractImagesFromVimeo
    
    # Sizes available: small '100x75', medium '200x150', large '640'.
    DEFAULT_SIZE = '640'
    EXTRACT_URL_PATTERN = /player\.vimeo\.com\/(?:v\/|.+?&v=|video\/)\w+/i
    EXTRACT_VID_PATTERN = /(?<=v\/|video\/)(?<vid>\w+)/i

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
      "https://i.vimeocdn.com/video/#{vid}_#{DEFAULT_SIZE}.webp"
    end
  end
end
