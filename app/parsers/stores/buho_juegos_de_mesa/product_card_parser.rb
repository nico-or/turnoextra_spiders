# frozen_string_literal: true

module Stores
  module BuhoJuegosDeMesa
    class ProductCardParser <
      EcommerceEngines::Shopify::ProductCardParser
      def default_selectors
        super.merge(
          {
            title: "div.product-card__name",
            price: "div.product-card__price"
          }
        )
      end

      def price
        Helpers.scan_int(price_node.text)
      end

      def stock?
        true
      end

      private

      def price_node
        price_node = node.at_css(selectors[:price])
        return unless price_node

        price_node.children.last
      end
    end
  end
end
