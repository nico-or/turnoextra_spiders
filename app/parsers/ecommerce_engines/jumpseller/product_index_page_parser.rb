# frozen_string_literal: true

module EcommerceEngines
  module Jumpseller
    class ProductIndexPageParser < Base::ProductIndexPageParser
      def default_selectors
        {
          index_product: ".product-block",
          next_page: "li.next a"
        }
      end
    end
  end
end
