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

      selector :index_product, "ul.products li.product"
      selector :next_page, "nav.woocommerce-pagination li a.next"
      selector :title, "h2"
      selector :url, "a"

      private

      def get_price(node)
        price_node = node.css("span.price bdi").last
        scan_int(price_node.text) if price_node
      end

      def in_stock?(node)
        !node.classes.include?("outofstock")
      end

      def get_image_url(node, _url)
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
