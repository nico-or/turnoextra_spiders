# frozen_string_literal: true

module EcommerceEngines
  module Jumpseller
    # Base spider class for all stores build with Jumpseller
    class Spider < ApplicationSpider
      private

      def get_image_url(node, _url)
        split_string = get_selector(:image_split)
        # example: https://cdnx.jumpseller.com/store-name/image/13909331/split_string/230/260?1610821805
        node.at_css("img")["src"]&.split("/#{split_string}")&.first
      rescue NoMethodError
        nil
      end
    end
  end
end
