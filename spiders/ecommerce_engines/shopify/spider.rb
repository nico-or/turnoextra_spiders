# frozen_string_literal: true

module EcommerceEngines
  module Shopify
    # Base spider class for all stores build with Shopify
    class Spider < ApplicationSpider
      selector :url, "a"

      def parse_product_node(node, url:)
        {
          url: get_url(node, url),
          title: get_title(node),
          price: get_price(node),
          stock: purchasable?(node),
          image_url: get_image_url(node)
        }
      end

      def format_image_url(url)
        uri = URI.parse(url)
        uri.scheme = "https"
        uri.query = nil
        uri.to_s
      end
    end
  end
end
