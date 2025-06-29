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

      # Parses product title from product image url slug
      # Example: https://www.example.com/vendorID-home_default/name-slug.jpg
      def image_slug_title(node)
        url = node.at_css("img[alt]")&.attr("src")
        return unless url

        File.basename(url, ".jpg").gsub("-", " ")
      end

      # Parses product title from product url slug
      # Example: https://www.example.com/category/vendorID-name-slug.html
      def product_slug_title(node)
        url = node.at_css("a")&.attr("href")
        return unless url

        File.basename(url, ".html").split("-")[1..].join(" ")
      end

      # Long product titles are truncated with ellipsis.
      # Product title is parsed from url slugs as a fallback
      def title_from_slug(node)
        image_slug_title(node) || product_slug_title(node)
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
