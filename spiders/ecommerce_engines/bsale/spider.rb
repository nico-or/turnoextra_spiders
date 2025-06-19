# frozen_string_literal: true

module EcommerceEngines
  module Bsale
    # Base spider class for all stores build with Bsale
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

      def get_image_url(node)
        tag = get_selector(:image_tag)
        attr = get_selector(:image_attr)
        node.at_css(tag).attr(attr).then do |url|
          uri = URI.parse(url)
          uri.query = nil
          uri.to_s
        end
      rescue NoMethodError
        nil
      end
    end
  end
end
