# frozen_string_literal: true

module Stores
  module Shivano
    class ProductCardParser < Base::ProductParser
      def default_selectors
        {
          title: "h5 a.product-name span.list-name",
          url: "h5 a.product-name",
          price: "span.price",
          stock: "span.availability span.out-of-stock",
          image_tag: "img",
          image_attr: "src"
        }
      end

      def image_url
        return unless image_rel_url

        Helpers.absolute_url(image_rel_url, base_url:)
      end

      private

      def image_node
        node.at_css(selectors[:image_tag])
      end

      def image_rel_url
        image_node&.attr(selectors[:image_attr])&.sub("home_default", "large_default")
      end
    end
  end
end
