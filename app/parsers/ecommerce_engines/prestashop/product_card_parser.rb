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
        image_node_url_large
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

      def image_node
        node.at_css(selectors[:image_tag])
      end

      def image_node_url
        image_node&.attr(selectors[:image_attr])
      end

      def image_node_url_large
        image_node_url&.sub("home_default", "large_default")
      end
    end
  end
end
