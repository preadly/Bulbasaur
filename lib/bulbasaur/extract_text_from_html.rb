module Bulbasaur
  
  class ExtractInnerTextFromHTML

    def initialize(html)
      @html = html
    end

    def call
      Nokogiri::HTML(@html).inner_text.to_s
    end

  end
end
