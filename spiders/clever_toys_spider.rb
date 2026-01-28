# frozen_string_literal: true

# Clever Toys store spider
# Engine: WooCommerce + Woodmart Theme
class CleverToysSpider < ApplicationSpider
  @name = "clever_toys_spider"
  @store = {
    name: "Clever Toys",
    url: "https://www.clevertoys.cl/"
  }
  @start_urls = [
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/aventuras/?per_page=36",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/cartas/?per_page=36",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/cooperativo/?per_page=36",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/estrategia/?per_page=36",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/familiar/?per_page=36",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/infantil/?per_page=36",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/party-game/?per_page=36",
    "https://www.clevertoys.cl/categoria-producto/juegos-de-mesa/wargame/?per_page=36"
  ]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "div.products div.product",
      next_page: "div.products-footer a.woodmart-load-more[href]"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser,
    selectors: {
      price: "span.price span.amount"
    }
  )
end
