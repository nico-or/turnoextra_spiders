# frozen_string_literal: true

module EcommerceEngines
  module Shopify
    class ProductCardParser < Base::ProductParser
      def default_selectors
        {
          url: "a",
          image_tag: "img",
          image_attr: "src"
        }
      end

      def image_url
        formatted_image_url
      rescue NoMethodError
        nil
      end

      private

      def image_node_url_raw
        case selectors[:image_attr]
        when "srcset"
          image_rel_url.split[-2]
        else
          image_rel_url
        end
      end

      def formatted_image_url
        uri = URI.parse(image_node_url_raw)
        uri.scheme = "https"
        uri.query = nil
        uri.to_s
      rescue URI::InvalidURIError
        nil
      end
    end
  end
end
