module Stores
  module Soletta
    class ProductIndexPageParser < EcommerceEngines::Bsale::ProductIndexPageParser
      def default_selectors
        {
          index_product: "div.bs-product",
          next_page: "ul.pagination li:last-child a.page-link[href]"
        }
      end

      def next_page_url
        next_page = node.at_css(selectors[:next_page])
        return if next_page.nil?
        return if next_page[:href] == "#"

        Helpers.absolute_url(next_page[:href], base_url:)
      end
    end
  end
end
