# frozen_string_literal: true

module Stores
  module Jugones
    class ProductCardParser < Base::ProductParser
      def default_selectors
        {
          title: "a.modelo",
          url: "a.modelo",
          stock: "a.precio.reserva",
          image_tag: "img",
          image_attr: "src"
        }
      end

      def price
        Helpers.scan_int(price_node&.text)
      end

      def image_url
        return unless image_rel_url

        Helpers.absolute_url(image_rel_url, base_url:)
      end

      private

      def regular_price
        node.at_css("a.precio")&.children&.[](0)
      end

      def discount_price
        node.at_css("a.precio.oferta")&.children&.[](2)
      end

      def price_node
        discount_price || regular_price
      end

      def image_rel_url
        # Example: https://www.jugones.cl/img/cache/140x140_100_172828401616969534121681488307wow1.jpg
        super&.sub(%r{cache/\d+x\d+_\d+_}, "productos/")
      end
    end
  end
end
