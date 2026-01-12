# frozen_string_literal: true

module Stores
  module PiedraBruja
    class ProductCardParser <
      EcommerceEngines::Shopify::ProductCardParser
      def default_selectors
        super.merge(
          {
            title: "a.product-item__title"
          }
        )
      end

      def price
        price_node = discount_price || regular_price
        return unless price_node

        Helpers.scan_int(price_node.children.last.text)
      end

      def stock?
        true
      end

      private

      def regular_price
        node.at_css("span.price")
      end

      def discount_price
        node.at_css("span.price--highlight")
      end
    end
  end
end
