# frozen_string_literal: true

module Stores
  module Diverti
    class ProductCardParser < EcommerceEngines::Prestashop::ProductCardParser
      # TODO: remove explicit super.merge call
      def default_selectors
        super.merge(
          {
            stock: "div.ago"
          }
        )
      end

      def stock?
        node.at_css(selectors[:stock]).text.strip.empty?
      end
    end
  end
end
