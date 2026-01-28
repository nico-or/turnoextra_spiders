# frozen_string_literal: true

module EcommerceEngines
  module WooCommerce
    class ProductCardParser < Base::ProductParser
      def default_selectors
        {
          url: "a",
          title: "h2,h3",
          price: "span.price bdi, span.amount bdi",
          stock: "outofstock",
          img_sized_attr: "src",
          img_srcset_attr: "srcset"
        }
      end

      def price
        price_node = node.css(selectors[:price])&.last
        return unless price_node

        Helpers.scan_int(price_node.text)
      end

      def stock?
        !node.classes.include?(selectors[:stock])
      end

      def image_url
        image_url_from_sized || image_url_from_srcset
      end

      private

      def image_url_from_sized
        # Example URL: "https://example.com/wp-content/uploads/yyyy/mm/filename-300x300.png"
        full_url = node.at_css("img").[](selectors[:img_sized_attr])
        match = full_url.match(/(?<base>.+?)(?<size>-\d+x\d+)?(?<ext>\.\w+)$/)
        return unless match

        "#{match[:base]}#{match[:ext]}"
      rescue NoMethodError
        nil
      end

      def image_url_from_srcset
        node.at_css("img")
            .[](selectors[:img_srcset_attr])
            .split(",")
            .last
            .split
            .first
      rescue NoMethodError
        nil
      end
    end
  end
end
