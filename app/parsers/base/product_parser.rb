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
      rel_url = node.at(selectors[:url])[:href]
      Helpers.absolute_url(rel_url, base_url:)
    end

    def title
      text = node.at(selectors[:title])&.text || ""
      text.strip.gsub(/\s+/, " ").strip
    end

    def price
      price_node = node.at(selectors[:price])
      return unless price_node

      Helpers.scan_int(price_node.text)
    end

    def stock?
      node.at(selectors[:stock]).nil?
    end

    def purchasable?
      stock?
    end
  end
end
