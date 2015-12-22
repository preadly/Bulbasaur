module Bulbasaur
  class NormalizeImageSrcSet 
    
    REGEX_FIND_WIDTH  = /(\d+)w/i
    REGEX_FIND_HEIGHT = /(\d+)h/i
    
    def initialize(html)
      @html = html
    end
    
    def call
      parsed_html = Nokogiri::HTML::DocumentFragment.parse(@html)
      parsed_html.css("img[srcset]").each do |img|
        image = extract_src_set_attribute(img)
        img.set_attribute("src", image[:url])
        img.set_attribute("width", image[:width]) if image[:width]
        img.set_attribute("height", image[:height]) if image[:height]
      end
      parsed_html.to_s
    end
    
    private
    
    def extract_src_set_attribute(img)
      itens = img.get_attribute("srcset").split(",")
      images = []
      itens.each do |item|
        srcset_item = item.split(" ")
        image_object = {
          url: extract_url(srcset_item), 
          width: extract_width(srcset_item), 
          height: extract_height(srcset_item)
        }
        images << image_object
      end
      get_better_image(images)
    end
    
    def extract_width(itens)
      extract_by_regex(itens, REGEX_FIND_WIDTH)
    end
    
    def extract_height(itens)
      extract_by_regex(itens, REGEX_FIND_HEIGHT)
    end
    
    def extract_url(srcset_item)
      srcset_item[0]
    end
    
    def extract_by_regex(itens, regex)
      value = itens.select{ |item| item =~ regex }.first
      value = value.match(regex).captures.first if value
      value
    end
    
    def get_better_image(itens)
      images = Array.new
      images.concat itens.select{ |img| !img[:width] && !img[:height] }.each{ |img| img[:area] = 0 }
      images.concat itens.select{ |img| !img[:width] &&  img[:height] }.each{ |img| img[:area] = img[:height] }
      images.concat itens.select{ |img|  img[:width] && !img[:height] }.each{ |img| img[:area] = img[:width]  }
      images.concat itens.select{ |img|  img[:width] &&  img[:height] }.each{ |img| img[:area] = img[:width].to_i * img[:height].to_i }  
      images = images.sort { |a, b| b[:area] <=> a[:area] }
      images.first
    end

  end
end
