module EcommerceEngines
  module Bsale
    class ProductIndexPageParser < Base::ProductIndexPageParser
      def default_selectors
        {
          index_product: "div.bs-collection section.grid__item",
          next_page: "ul.pagination li:last-child a"
        }
      end
    end
  end
end
