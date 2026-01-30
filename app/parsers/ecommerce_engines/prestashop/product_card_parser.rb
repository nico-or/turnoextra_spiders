# frozen_string_literal: true

module EcommerceEngines
  module Prestashop
    class ProductCardParser < Base::ProductParser
      def default_selectors
        {
          url: ".product-title a",
          title: ".product-title",
          price: "span.price",
          stock: "li.out_of_stock",
          image_tag: "img",
          image_attr: "src"
        }
      end

      def image_url
        super&.sub("home_default", "large_default")
      end

      def title
        [super, alt_title, slug_title].find { !it.end_with?("...") }
      end

      private

      def alt_title
        node.at_css("img")&.attr(:alt)
      end

      # Parses product title from product url slug
      # Example: https://www.example.com/category/vendorID-name-slug.html
      # Becomes: name slug
      def slug_title
        File.basename(url, ".html").split("-")[1..].join(" ")
      end
    end
  end
end
