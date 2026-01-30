# frozen_string_literal: true

module Stores
  module JugandoAndo
    class ProductCardParser < Base::ProductParser
      def default_selectors
        {
          url: "a",
          title: "h3",
          price: "span.text-nowrap",
          img_tag: "div.bg-img",
          img_attr: "data-bg"
        }
      end

      def purchasable?
        true
      end

      def image_url
        return unless image_rel_url

        Helpers.absolute_url(image_rel_url, base_url:)
      end

      private

      def image_node
        node.at_css(selectors[:img_tag])
      end

      def image_rel_url
        image_node&.[](selectors[:img_attr])
      end
    end
  end
end
