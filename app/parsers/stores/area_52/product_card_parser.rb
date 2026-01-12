# frozen_string_literal: true

module Stores
  module Area52
    class ProductCardParser <
      EcommerceEngines::Shopify::ProductCardParser
      def default_selectors
        super.merge(
          {
            title: "h3",
            price: "span.price-item--sale",
            stock: "span.badge"
          }
        )
      end

      def stock?
        node.at_css(selectors[:stock])&.text != "Agotado"
      end
    end
  end
end
