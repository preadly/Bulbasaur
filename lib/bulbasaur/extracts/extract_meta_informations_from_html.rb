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
        if valid? meta_information, name, value
          meta_informations << { name: meta_information[name], value: meta_information[value] }
        end
      end
      meta_informations
    end

    private

    def for_each_meta_information(&block)
      if @html
        Nokogiri::HTML(@html).xpath('//meta').map(&:to_h).each &block
        Nokogiri::HTML(@html).xpath('//link').map(&:to_h).each &block
      end
    end

    def name_of(meta_information)
      catch_key meta_information, /name|property|rel/i
    end

    def value_of(meta_information)
      catch_key meta_information, /value|content|href/i
    end

    def valid?(meta_information, name, value)
      !meta_information[name].empty? && !meta_information[value].empty?
    end

    def catch_key(hash, regex)
      key_name = nil
      hash.select { |key| key_name = key if key =~ regex }
      key_name
    end
  end
end