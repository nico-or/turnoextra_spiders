# frozen_string_literal: true

module EcommerceEngines
  module Shopify
    # Base spider class for all stores build with Shopify
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

      def get_title(node, selector)
        node.at_css(selector).text.strip
      end

      def get_price(node, selector)
        price_node = node.at_css(selector)
        return unless price_node

        scan_int(price_node.text)
      end

      def in_stock?(node, selector)
        node.at_css(selector).nil?
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
