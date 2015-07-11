module Operations::ExtractTextFromHtml
  require "nokogiri"

  def self.call(html)
    Nokogiri::HTML(html).inner_text.to_s
  end
end
