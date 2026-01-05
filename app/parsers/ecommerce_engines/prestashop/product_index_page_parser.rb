module EcommerceEngines
  module Prestashop
    class ProductIndexPageParser < Base::ProductIndexPageParser
      def default_selectors
        {
          index_product: "div#js-product-list article",
          next_page: "nav.pagination li a[@rel=next]"
        }
      end
    end
  end
end
