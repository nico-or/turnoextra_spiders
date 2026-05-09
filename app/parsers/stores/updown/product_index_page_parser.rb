# frozen_string_literal: true

module Stores
  module Updown
    class ProductIndexPageParser < EcommerceEngines::WooCommerce::ProductIndexPageParser
      def default_selectors
        {
          index_product: "div.wd-products div.wd-product",
          next_page: "ul.page-numbers a.next"
        }
      end

      def next_page_url
        url = super
        return if url.nil?

        uri = URI.parse(url)
        query_string = URI.encode_www_form("stock_status" => "instock")
        uri.query = query_string
        uri.to_s
      rescue URI::BadURIError
        nil
      end
    end
  end
end
