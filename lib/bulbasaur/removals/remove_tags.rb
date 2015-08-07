module Bulbasaur
  class RemoveTags
    def initialize(html, banned_tags)
      @html = html
      @banned_tags = banned_tags
    end

    def call
      parsed_html = Nokogiri::HTML::DocumentFragment.parse @html
      @banned_tags.each { |tag| parsed_html.css(tag).remove }
      parsed_html.to_s
    end
  end
end