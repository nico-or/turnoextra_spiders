# frozen_string_literal: true

module Stores
  module Jugones
    class ProductIndexPageParser < EcommerceEngines::Prestashop::ProductIndexPageParser
      def default_selectors
        {
          index_product: "div.producto"
        }
      end

      def next_page_url
        nil
      end
    end
  end
end
