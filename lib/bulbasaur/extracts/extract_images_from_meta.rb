module Bulbasaur
  class ExtractImagesFromMeta
    PROPERTY = 'og:image'

    def initialize(html)
      @html = html
    end

    def call
      meta_informations = Bulbasaur::ExtractMetaInformationsFromHTML.new(@html).call
      image_urls = image_meta_tags(meta_informations).map { |meta| { url: meta[:value], source: 'meta' } }
      image_urls
    end

    private

    def image_meta_tags(meta_informations)
      meta_informations.select { |meta| meta[:name] == PROPERTY }
    end
  end
end