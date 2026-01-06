module Stores
  module ElArcanista
    class ProductIndexPageParser < Base::ProductIndexPageParser
      def default_selectors
        {
          index_product: "product-card",
          next_page: "infinite-scroll"
        }
      end

      def next_page_url
        next_page = node.at_css(selectors[:next_page])
        return unless next_page

        Helpers.absolute_url(next_page["data-url"], base_url:)
      end
    end
  end
end
