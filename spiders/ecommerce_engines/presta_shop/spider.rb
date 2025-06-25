# frozen_string_literal: true

module EcommerceEngines
  module PrestaShop
    # Base spider class for all stores build with PrestaShop
    class Spider < ApplicationSpider
      class << self
        attr_reader :_title_strategy

        TITLE_STRATEGY = %i[slug].freeze

        def title_strategy(strategy)
          raise ArgumentError, "Unknown strategy: #{strategy}" unless TITLE_STRATEGY.include?(strategy)

          @_title_strategy = strategy
        end
      end

      selector :index_product, "div#js-product-list article"
      selector :next_page, "nav.pagination li a[@rel=next]"
      selector :title, ".product-title"
      selector :price, "span.price"
      selector :stock, "li.out_of_stock"
      selector :url, ".product-title a"

      private

      def title_from_slug(node)
        url = node.at_css("img")["src"]
        File.basename(url, ".jpg").gsub("-", " ")
      end

      def get_title(node)
        case self.class._title_strategy
        when :slug
          title_from_slug(node)
        else
          super
        end
      end

      def get_image_url(node, _url)
        node.at_css("img")["src"].sub("home_default", "large_default")
      rescue NoMethodError
        nil
      end
    end
  end
end
