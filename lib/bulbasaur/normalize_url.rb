module Bulbasaur

  class NormalizeURL

    def initialize(base_url, context_url)
      @base_url = base_url
      @context_url = context_url
    end

    def call
      if @context_url =~ /^https?:\/\//
        URI::encode @context_url
      else
        URI::join(@base_url, @context_url).to_s
      end
    rescue
      raise ArgumentError, "Not possible normalize url, check the params [base_url: #{@base_url}, context_url: #{@context_url}]"
    end

  end
end
