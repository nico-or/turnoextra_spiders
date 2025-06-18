# frozen_string_literal: true

module EcommerceEngines
  module PrestaShop
    # Base spider class for all stores build with PrestaShop
    class Spider < ApplicationSpider
      def parse_index(response, url:, data: {})
        listings = response.css("div#js-product-list article")
        listings.map { |listing| parse_product_node(listing, url:) }
      end

      def parse_product_node(node, url:)
        {
          url: get_url(node),
          title: get_title(node),
          price: get_price(node),
          stock: purchasable?(node),
          image_url: get_image_url(node)
        }
      end

      def next_page_url(response, url)
        next_page_node = response.at_css("nav.pagination li a[@rel=next]")
        return unless next_page_node

        absolute_url(next_page_node[:href], base: url)
      end

      private

      def get_url(node)
        node.at_css(".product-title a")[:href]
      end

      def get_title(node)
        node.at_css(".product-title").text.strip
      end

      def get_price(node)
        price_node = node.at_css("span.price")
        scan_int(price_node.text) if price_node
      end

      def in_stock?(node)
        node.at_css("li.out_of_stock").nil?
      end

      def purchasable?(node)
        in_stock?(node)
      end

      def get_image_url(node)
        node.at_css("img")["data-full-size-image-url"]
      rescue NoMethodError
        nil
      end
    end
  end
end
