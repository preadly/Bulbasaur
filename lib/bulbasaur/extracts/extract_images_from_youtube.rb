module Bulbasaur

  class ExtractImagesFromYoutube

    EXTRACT_URL_PATTERN = /www\.youtube(?:-nocookie)?\.com\/(?:v|embed)\/[a-zA-Z0-9-]+/i
    EXTRACT_VID_PATTERN = /(?<=v|embed)\/(?<vid>[a-zA-Z0-9-]+)/i

    def initialize(html)
      @html = html
    end

    def call
      images = Array.new
      @html.scan(EXTRACT_URL_PATTERN).each do |video|
        vid = get_vid(video)
        images << { url: image_url(vid), video_url: video, source: 'youtube' }
      end
      images
    end

    private

    def get_vid(video)
      EXTRACT_VID_PATTERN.match(video)[:vid]
    end

    def image_url(vid)
      image = image_url_max_resolution(vid)
      response = Net::HTTP.get_response(URI(image))
      case response
      when Net::HTTPSuccess then
        return image_url_max_resolution(vid)
      else
        return image_url_fallback(vid)
      end
    end

    def image_url_max_resolution(vid)
      "http://img.youtube.com/vi/#{vid}/maxresdefault.jpg"
    end

    def image_url_fallback(vid)
      "http://img.youtube.com/vi/#{vid}/0.jpg"
    end

  end
end
