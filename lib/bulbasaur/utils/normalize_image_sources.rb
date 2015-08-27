module Bulbasaur
  class NormalizeImageSources
    DOMAIN_REGEX = /^(?:https?:\/\/)?(?:[^@\n]+@)?(?:www\.)?([^:\/\n]+)/im

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
      element.set_attribute 'src', lazy_load_url(element, element.xpath(attr).text)
      remove_target_attrs_from element
    end

    def lazy_load_url(element, text)
      text_match = text.match(DOMAIN_REGEX).to_s
      element_match = element.css('@src').text.match(DOMAIN_REGEX).to_s
      element_match.empty? || text_match == element_match ? text : "#{element_match}/#{text}"
    end

    def remove_target_attrs_from(element)
      @target_attrs.each { |attr| element.xpath("@#{attr}").remove }
    end
  end
end