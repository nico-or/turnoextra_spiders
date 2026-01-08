# frozen_string_literal: true

module Stores
  module LaTribuGames
    # TODO: rename parser since it's used by multiple spiders:
    # - LaTribuGamesSpider
    # - LautaroJuegosSpider
    # - Magic4EverSpider
    # - RivendelElConcilioSpider
    class ProductCardParser < EcommerceEngines::Jumpseller::ProductCardParser
      # TODO: remove explicit super.merge call
      def default_selectors
        super.merge(
          {
            stock: "a.not-available",
            price: ".product-block-normal, .product-block-list"
          }
        )
      end

      def title
        node.at_css("img")[:alt].strip
      end
    end
  end
end
