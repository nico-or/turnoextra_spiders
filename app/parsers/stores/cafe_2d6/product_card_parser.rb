# frozen_string_literal: true

module Stores
  module Cafe2d6
    class ProductCardParser <
      EcommerceEngines::Shopify::ProductCardParser
      def default_selectors
        super.merge(
          {
            url: "a",
            title: "h3",
            stock: "a.add-to-agotado"
          }
        )
      end

      def price
        price_node = discount_price || regular_price
        return unless price_node

        Helpers.scan_int(price_node.text)
      end

      private

      def regular_price
        node.at_css("p.price")
      end

      def discount_price
        price_node = node.at_css("p.price.sale")
        return unless price_node

        price_node.children.first
      end
    end
  end
end
