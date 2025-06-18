# frozen_string_literal: true

module EcommerceEngines
  module WooCommerce
    # Base spider class for all stores build with WooCommerce
    class Spider < ApplicationSpider
      class << self
        attr_reader :img_url_strategy

        def image_url_strategy(strategy)
          raise ArgumentError, "Unknown strategy: #{strategy}" unless %i[sized srcset].include?(strategy)

          @img_url_strategy = strategy
        end
      end

      def parse_index(response, url:, data: {})
        listings = response.css("ul.products li.product")
        listings.map { |listing| parse_product_node(listing, url:) }
      end

      def next_page_url(response, url)
        next_page = response.at_css("nav.woocommerce-pagination li a.next")
        return unless next_page

        absolute_url(next_page[:href], base: url)
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

      private

      def get_url(node)
        node.at_css("a")[:href]
      end

      def get_title(node)
        node.at_css("h2").text.strip
      end

      def get_price(node)
        price_node = node.css("span.price bdi").last
        scan_int(price_node.text) if price_node
      end

      def in_stock?(node)
        !node.classes.include?("outofstock")
      end

      def purchasable?(node)
        in_stock?(node)
      end

      def get_image_url(node)
        case self.class.img_url_strategy
        when :srcset
          image_url_from_srcset(node)
        when :sized
          image_url_from_sized(node)
        end
      rescue NoMethodError
        nil
      end

      def image_url_from_srcset(node)
        node.at_css("img")["srcset"].split(",").last.split.first
      end

      def image_url_from_sized(node)
        # Example URL: "https://example.com/wp-content/uploads/yyyy/mm/filename-300x300.png"
        full_url = node.at_css("img")["src"]
        match = full_url.match(/(?<base>.+?)(?<size>-\d+x\d+)?(?<ext>\.\w+)$/)
        return unless match

        "#{match[:base]}#{match[:ext]}"
      end
    end
  end
end
