# frozen_string_literal: true

module Stores
  module Entrejuegos
    class ProductCardParser < EcommerceEngines::Prestashop::ProductCardParser
      def price?
        !price.nil?
      end

      def purchasable?
        stock? && price?
      end
    end
  end
end
