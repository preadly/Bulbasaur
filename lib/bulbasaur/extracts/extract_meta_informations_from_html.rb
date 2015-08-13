module Bulbasaur
  class ExtractMetaInformationsFromHTML

    def initialize(html)
      @html = html
    end

    def call
      meta_informations = []
      for_each_meta_information do |meta_information|
        name = name_of meta_information
        value = value_of meta_information
        meta_informations << { name: name, value: value } unless name.nil? || value.nil?
      end
      meta_informations
    end

    private

    def for_each_meta_information(&block)
      if @html
        Nokogiri::HTML(@html).xpath('//meta').each &block
        Nokogiri::HTML(@html).xpath('//link').each &block
      end
    end

    def name_of(meta_information)
      include_attribute? %w(name property rel), meta_information
    end

    def value_of(meta_information)
      include_attribute? %w(value content href), meta_information
    end

    def include_attribute?(attributes, tag)
      attributes.each do |attr|
        return tag.attribute(attr).to_s if tag.attributes.include?(attr)
      end
      nil
    end
  end
end