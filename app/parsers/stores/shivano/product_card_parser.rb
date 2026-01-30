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

      def image_rel_url
        super&.sub("home_default", "large_default")
      end
    end
  end
end
