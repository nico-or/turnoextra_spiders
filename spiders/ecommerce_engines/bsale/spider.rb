# frozen_string_literal: true

module EcommerceEngines
  module Bsale
    # Base spider class for all stores build with Bsale
    class Spider < ApplicationSpider
      selector :title,  "h3.bs-collection__product-title"
      selector :stock,  "div.bs-collection__stock"
      selector :price,  "div.bs-collection__product-final-price"
      selector :url, "a"
      selector :image_tag, "img"
      selector :image_attr, "src"

      private

      def get_image_url(node, _url)
        tag = get_selector(:image_tag)
        attr = get_selector(:image_attr)
        node.at_css(tag).attr(attr).then do |url|
          uri = URI.parse(url)
          uri.query = nil
          uri.to_s
        end
      rescue NoMethodError
        nil
      end
    end
  end
end
