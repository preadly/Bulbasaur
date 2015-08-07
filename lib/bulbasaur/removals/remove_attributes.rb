module Bulbasaur
  class RemoveAttributes
    def initialize(html, banned_attrs)
      @html = html
      @banned_attrs = banned_attrs
    end

    def call
      parsed_html = Nokogiri::HTML::DocumentFragment.parse @html
      @banned_attrs.each { |attr| parsed_html.xpath('.//@style').remove }
      parsed_html.to_s
    end
  end
end