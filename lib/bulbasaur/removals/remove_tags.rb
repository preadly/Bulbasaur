module Bulbasaur
  class RemoveTags
    
    SELECTORS_EMPTY_ANALYSE = "div, p"
    
    def initialize(html, banned_tags, remove_empty_tags = false)
      @html = html
      @banned_tags = banned_tags
      @remove_empty_tags = remove_empty_tags
    end
    
    def call
      parsed_html = Nokogiri::HTML::DocumentFragment.parse(@html)
      remove_empty_tags(parsed_html) if @remove_empty_tags
      @banned_tags.each { |tag| parsed_html.css(tag).remove }
      parsed_html.to_s
    end
    
    private
    
      def remove_empty_tags(parsed_html)
        parsed_html.css(SELECTORS_EMPTY_ANALYSE).each do |tag|
          tag.remove if tag.content.strip.empty? && tag.children.select{ |c| c.name != "text" }.length == 0
        end
      end

  end
end
