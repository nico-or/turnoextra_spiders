# frozen_string_literal: true

module EcommerceEngines
  module Bsale
    class ProductCardParser < Base::ProductParser
      def default_selectors
        {
          url: "a",
          title: "h3.bs-collection__product-title",
          price: "div.bs-collection__product-final-price",
          stock: "div.bs-collection__stock",
          image_tag: "img",
          image_attr: "src"
        }
      end

      def image_url
        image_url_without_query
      end

      private

      def image_node
        node.at_css(selectors[:image_tag])
      end

      def image_url_with_query
        image_node&.attr(selectors[:image_attr])
      end

      def image_url_without_query
        uri = URI.parse(image_url_with_query)
        uri.query = nil
        uri.to_s
      rescue URI::BadURIError
        nil
      end
    end
  end
end
