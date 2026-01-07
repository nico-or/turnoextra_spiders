# frozen_string_literal: true

module EcommerceEngines
  module WooCommerce
    class ProductIndexPageParser < Base::ProductIndexPageParser
      def default_selectors
        {
          index_product: "ul.products li.product",
          next_page: "nav.woocommerce-pagination li a.next"
        }
      end
    end
  end
end
