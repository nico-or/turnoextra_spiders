# frozen_string_literal: true

module Stores
  module DementeGames
    class ProductIndexPageParser < EcommerceEngines::Prestashop::ProductIndexPageParser
      def next_page_url
        next_page = node.at_css(selectors[:next_page])
        return if next_page.nil?
        return if next_page.classes.include?("disabled")

        Helpers.absolute_url(next_page[:href], base_url:)
      end
    end
  end
end
