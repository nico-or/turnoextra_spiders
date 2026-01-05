# frozen_string_literal: true

module EcommerceEngines
  module Jumpseller
    # Base spider class for all stores build with Jumpseller
    class Spider < ApplicationSpider
      SPLIT_REGEX = %r{/(resize|thumb)}

      selector :index_product, ".product-block"
      selector :next_page, "li.next a"
      selector :url, "a"
      selector :title, "a.product-block__name"
      selector :price, "div.product-block__price"
      selector :stock, "div.product-block__disabled"

      private

      def get_image_url(node, _url)
        node.at_css("img")["src"]&.split(SPLIT_REGEX)&.first
      rescue NoMethodError
        nil
      end
    end
  end
end
