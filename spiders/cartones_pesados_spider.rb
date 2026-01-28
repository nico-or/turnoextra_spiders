# frozen_string_literal: true

# Cartones Pesados store spider
class CartonesPesadosSpider < ApplicationSpider
  @name = "cartones_pesados_spider"
  @store = {
    name: "Cartones Pesados",
    url: "https://cartonespesados.cl"
  }
  @start_urls = ["https://cartonespesados.cl/shop/"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "ul li.product",
      next_page: "a.wp-block-query-pagination-next"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductCardParser
  )
end
