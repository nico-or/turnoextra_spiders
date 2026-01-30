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
          stock: css_stock_selector,
          image_tag: "img",
          image_attr: "src"
        }
      end

      def image_url
        image_rel_url&.split(SPLIT_REGEX)&.first
      end

      private

      def css_price_selector
        ".product-block__price--new,
        .product-block__price--discount > span:first-child,
        .product-block__price:not(.product-block__price--discount)"
      end

      def css_stock_selector
        "div.product-block__disabled,
        .product-block__label--status"
      end
    end
  end
end
