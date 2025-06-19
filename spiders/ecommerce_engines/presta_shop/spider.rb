# frozen_string_literal: true

module EcommerceEngines
  module PrestaShop
    # Base spider class for all stores build with PrestaShop
    class Spider < ApplicationSpider
      selector :index_product, "div#js-product-list article"
      selector :next_page, "nav.pagination li a[@rel=next]"
      selector :title, ".product-title"
      selector :price, "span.price"
      selector :stock, "li.out_of_stock"

      def parse_product_node(node, url:)
        {
          url: get_url(node),
          title: get_title(node),
          price: get_price(node),
          stock: purchasable?(node),
          image_url: get_image_url(node)
        }
      end

      private

      def get_url(node)
        node.at_css(".product-title a")[:href]
      end

      def get_image_url(node)
        node.at_css("img")["data-full-size-image-url"]
      rescue NoMethodError
        nil
      end
    end
  end
end
