require 'nokogiri'

module Operations
  class CreateMetaInformations
    def initialize(post)
      @post = post
      @raw_post = post.raw_post
    end

    def call
      for_each_meta_information do |meta_information|
        name = name_of meta_information
        value = value_of meta_information
        if can_create? meta_information, name, value
          @post.meta_informations.create name: meta_information[name], value: meta_information[value]
        end
      end
    end

    private

    def for_each_meta_information(&block)
      if @raw_post.content
        Nokogiri::HTML(@raw_post.content).xpath('//meta').map(&:to_h).each &block
        Nokogiri::HTML(@raw_post.content).xpath('//link').map(&:to_h).each &block
      end
    end

    def name_of(meta_information)
      catch_key meta_information, /name|property|rel/i
    end

    def value_of(meta_information)
      catch_key meta_information, /value|content|href/i
    end

    def can_create?(meta_information, name, value)
      meta_information[name].present? && meta_information[value].present?
    end

    def catch_key(hash, regex)
      key_name = nil
      hash.select { |key| key_name = key if key =~ regex }
      key_name
    end
  end
end