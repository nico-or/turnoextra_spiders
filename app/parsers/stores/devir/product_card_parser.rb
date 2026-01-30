# frozen_string_literal: true

module Stores
  module Devir
    class ProductCardParser < Base::ProductParser
      def default_selectors
        {
          title: "strong a",
          url: "strong a",
          price_tag: "span[data-price-type=finalPrice]",
          price_attr: "data-price-amount",
          image_tag: "img.product-image-photo",
          image_attr: "src"
        }
      end

      def price
        return unless price_text

        Helpers.scan_int(price_text)
      end

      def image_url
        return unless image_rel_url

        Helpers.absolute_url(image_rel_url, base_url:)
      end

      def stock?
        node.at_css("form")&.attr("data-role") == "tocart-form"
      end

      private

      def price_node
        node.at_css(selectors[:price_tag])
      end

      def price_text
        price_node&.attr(selectors[:price_attr])
      end

      def image_node
        node.at_css(selectors[:image_tag])
      end

      def image_rel_url
        image_node&.attr(selectors[:image_attr])
      end
    end
  end
end
