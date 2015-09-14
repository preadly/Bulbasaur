module Bulbasaur
  class NormalizeImageSources
    def initialize(html, target_attrs)
      @html = html
      @target_attrs = target_attrs
    end

    def call
      parsed_html = Nokogiri::HTML::DocumentFragment.parse @html
      parsed_html.css('img').each do |element|
        check_for_attrs element
      end
      parsed_html.to_s
    end

    private

    def check_for_attrs(element)
      @target_attrs.each do |attr|
        if element.at "@#{attr}"
          adjust element, "@#{attr}"
          break
        end
      end
    end

    def adjust(element, attr)
      element.set_attribute 'src', element.xpath(attr).text
      remove_target_attrs_from element
    end

    def remove_target_attrs_from(element)
      @target_attrs.each { |attr| element.xpath("@#{attr}").remove }
    end
  end
end