# frozen_string_literal: true

module EcommerceEngines
  module Jumpseller
    # Base spider class for all stores build with Jumpseller
    class Spider < ApplicationSpider
      def parse_product_node(node, url:)
        {
          url: get_url(node, url),
          title: get_title(node),
          price: get_price(node),
          stock: purchasable?(node),
          image_url: get_image_url(node)
        }
      end

      private

      def get_image_url(node, split_string)
        # example: https://cdnx.jumpseller.com/store-name/image/13909331/split_string/230/260?1610821805
        node.at_css("img")["src"]&.split("/#{split_string}")&.first
      rescue NoMethodError
        nil
      end
    end
  end
end
