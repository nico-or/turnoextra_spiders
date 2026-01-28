# frozen_string_literal: true

module Stores
  module TopoToken
    class ProductCardParser < EcommerceEngines::WooCommerce::ProductCardParser
      # TODO: remove explicit super.merge call
      def default_selectors
        super.merge(
          {
            protected: "post-password-required"
          }
        )
      end

      def protected?
        node.classes.include?(selectors[:protected])
      end

      def purchasable?
        stock? && !protected?
      end
    end
  end
end
