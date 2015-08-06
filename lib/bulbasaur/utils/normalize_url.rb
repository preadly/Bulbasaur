module Bulbasaur
  class NormalizeURL
    def initialize(base_url, context_url)
      @base_url = base_url
      @context_url = context_url
    end

    def call
      url = (@context_url =~ /^https?:\/\//) ? @context_url : URI::join(@base_url, @context_url).to_s
      URI::encode URI::decode url
    rescue
      raise ArgumentError, "Unable to normalize URL. Params: [base_url: #{@base_url}, context_url: #{@context_url}]."
    end
  end
end
