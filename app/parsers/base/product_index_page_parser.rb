# frozen_string_literal: true

module Base
  class ProductIndexPageParser
    attr_reader :node, :base_url, :selectors

    def initialize(node, base_url:, selectors: {})
      @node = node
      @base_url = base_url
      @selectors = default_selectors.merge(selectors)
    end

    def default_selectors
      {}
    end

    def product_nodes
      node.css(selectors[:index_product])
    end

    def next_page_url
      next_page_node = node.at_css(selectors[:next_page])
      return unless next_page_node

      Helpers.absolute_url(next_page_node[:href], base_url:)
    end
  end
end
