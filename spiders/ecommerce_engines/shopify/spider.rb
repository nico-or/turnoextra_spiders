# frozen_string_literal: true

module EcommerceEngines
  module Shopify
    # Base spider class for all stores build with Shopify
    class Spider < ApplicationSpider
      @config = {
        before_request: {
          delay: 4..6
        }
      }

      selector :url, "a"
      selector :image_tag, "img"
      selector :image_attr, "src"

      def get_image_url(node, _url)
        image_node = image_node(node)
        url = image_url(image_node)
        format_image_url(url)
      rescue NoMethodError
        nil
      end

      def image_node(node)
        selector = get_selector(:image_tag)
        node.at_css(selector)
      end

      def image_url(node)
        selector = get_selector(:image_attr)
        url = extract_image_url(node)
        case selector
        when "srcset"
          url.split[-2]
        else
          url
        end
      end

      def extract_image_url(node)
        return unless node

        selector = get_selector(:image_attr)
        node.attr(selector)
      end

      def format_image_url(url)
        uri = URI.parse(url)
        uri.scheme = "https"
        uri.query = nil
        uri.to_s
      rescue URI::InvalidURIError
        nil
      end
    end
  end
end
