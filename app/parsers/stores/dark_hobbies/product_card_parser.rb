# frozen_string_literal: true

module Stores
  module DarkHobbies
    class ProductCardParser < EcommerceEngines::Shopify::ProductCardParser
      def default_selectors
        super.merge(
          {
            title: "h3",
            price: "div[ref=priceContainer] span.price",
            stock: "button[type=submit][disabled]"
          }
        )
      end

      def title
        slug_title
      end

      private

      # Parses product title from product url slug
      # Example: https://www.example.com/category/name-slug.html
      # Becomes: name slug
      def slug_title
        product_url_without_query
          .split("/")
          .[](-1)
          .gsub("-", " ")
      rescue StandardError
        nil
      end

      def product_url_without_query
        uri = URI.parse(url)
        uri.query = nil
        uri.to_s
      rescue URI::BadURIError
        nil
      end
    end
  end
end
