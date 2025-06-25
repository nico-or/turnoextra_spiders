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
      selector :url, ".product-title a"

      private

      def get_image_url(node, _url)
        node.at_css("img")["src"].sub("home_default", "large_default")
      rescue NoMethodError
        nil
      end
    end
  end
end
