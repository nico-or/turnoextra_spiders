# frozen_string_literal: true

module EcommerceEngines
  module Jumpseller
    class ProductCardParser < Base::ProductParser
      SPLIT_REGEX = %r{/(resize|thumb)}

      def default_selectors
        {
          url: "a",
          title: "a.product-block__name",
          price: css_price_selector,
          stock: "div.product-block__disabled",
          image_tag: "img",
          image_attr: "src"
        }
      end

      def image_url
        image_node_url_splitted
      end

      private

      def css_price_selector
        ".product-block__price--new,
        .product-block__price--discount > span:first-child,
        .product-block__price:not(.product-block__price--discount)"
      end

      def image_node
        node.at_css(selectors[:image_tag])
      end

      def image_node_url
        image_node&.attr(selectors[:image_attr])
      end

      def image_node_url_splitted
        image_node_url&.split(SPLIT_REGEX)&.first
      end
    end
  end
end
