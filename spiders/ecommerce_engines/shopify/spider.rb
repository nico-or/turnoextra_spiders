# frozen_string_literal: true

module EcommerceEngines
  module Shopify
    # Base spider class for all stores build with Shopify
    class Spider < ApplicationSpider
      selector :url, "a"

      def format_image_url(url)
        uri = URI.parse(url)
        uri.scheme = "https"
        uri.query = nil
        uri.to_s
      end
    end
  end
end
