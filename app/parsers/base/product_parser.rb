# frozen_string_literal: true

module Base
  class ProductParser
    attr_reader :node, :base_url, :selectors

    def initialize(node, base_url:, selectors: {})
      @node = node
      @base_url = base_url
      @selectors = default_selectors.merge(selectors)
    end

    def default_selectors
      {}
    end

    def url
      rel_url = node.at_css(selectors[:url])[:href]
      Helpers.absolute_url(rel_url, base_url:)
    end

    def title
      node.at_css(selectors[:title])&.text&.strip || ""
    end

    def price
      price_node = node.at_css(selectors[:price])
      return unless price_node

      Helpers.scan_int(price_node.text)
    end

    def stock?
      node.at_css(selectors[:stock]).nil?
    end

    def purchasable?
      stock?
    end
  end
end
