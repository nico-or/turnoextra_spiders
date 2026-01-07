# frozen_string_literal: true

module Stores
  module ElCalabozo
    class ProductIndexPageParser < EcommerceEngines::Bsale::ProductIndexPageParser
      def default_selectors
        {
          index_product: "div.Prod-item",
          next_page: "li.page-item.active + li.d-none a"
        }
      end

      def next_page_url
        next_page = node.at_css(selectors[:next_page])
        return if next_page.nil?

        Addressable::URI.parse(next_page[:href]).normalize.to_s
      end
    end
  end
end
