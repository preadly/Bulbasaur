require 'open-uri'

RemoteImageFailed = Class.new(StandardError)

module Operations
  class CreateRemoteImage
    def initialize(post, image_element)
      @post = post
      @remote_url = image_element[:url]
      @alt = image_element[:alt]
    end

    def call(&validation)
      validation ||= proc { true }
      # only add if image is present in post content and if image is big enough
      normalized_image_url = normalize_image_url @remote_url
      if validation.call(@remote_url, normalized_image_url)
        @post.post_images.create(
          remote_image_url: normalized_image_url, # this is for the carrierwave uploader
          original_image_url: @remote_url, # this is the field where we save the original url
          alt: @alt # This is the alt attribute of the image element
        )
      end
    rescue CarrierWave::DownloadError => e
      raise RemoteImageFailed, e
    end

    private

    def normalize_image_url(image_url)
      if image_url =~ /^https?:\/\//
        URI::encode image_url
      else
        URI::join(@post.url, image_url).to_s
      end
    rescue
      image_url
    end
  end
end
