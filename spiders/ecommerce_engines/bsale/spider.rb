# frozen_string_literal: true

module EcommerceEngines
  module Bsale
    # Base spider class for all stores build with Bsale
    class Spider < ApplicationSpider
      def parse_index(response, url:, selector:, data: {})
        listings = response.css(selector)
        listings.map { |listing| parse_product_node(listing, url:) }
      end

      def parse_product_node(node, url:)
        {
          url: get_url(node, url),
          title: get_title(node),
          price: get_price(node),
          stock: purchasable?(node),
          image_url: get_image_url(node)
        }
      end

      def next_page_url(response, url, selector)
        next_page_node = response.at_css(selector)
        return unless next_page_node

        absolute_url(next_page_node[:href], base: url)
      end

      private

      def get_url(node, url)
        rel_url = node.at_css("a")[:href]
        absolute_url(rel_url, base: url)
      end

      def get_price(node, selector)
        price_node = node.at_css(selector)
        return unless price_node

        scan_int(price_node.text)
      end

      def in_stock?(node, selector)
        node.at_css(selector).nil?
      end

      def get_image_url(node, attribute)
        node.at_css("img").attr(attribute).then do |url|
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
