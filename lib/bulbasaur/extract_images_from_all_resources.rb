module Bulbasaur
  
  class ExtractImagesFromAllResources
    
    def initialize(html)
      @html = html 
    end

    def call
      images = Array.new
      images = images + extract_images_html(@html)
      images = images + extract_images_youtube(@html)
      images = images + extract_images_vimeo(@html)
      images
    end

    private

    def extract_images_youtube(html)
      begin
        Bulbasaur::ExtractImagesFromYoutube.new(html).call
      rescue Exception => e
        []
      end
    end

    def extract_images_html(html)
      begin
        Bulbasaur::ExtractImagesFromHTML.new(html).call  
      rescue Exception => e
        []
      end
    end

    def extract_images_vimeo(html)
      begin
        Bulbasaur::ExtractImagesFromVimeo.new(html).call
      rescue Exception => e
        []
      end
    end

  end
end
