# frozen_string_literal: true

# La Mesa De Varas store spider
class LaMesaDeVarasSpider < ApplicationSpider
  @name = "la_mesa_de_varas_spider"
  @store = {
    name: "La Mesa De Varas",
    url: "https://lamesadevaras.cl/"
  }
  @start_urls = ["https://lamesadevaras.cl/9-juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Prestashop::ProductCardParser
  )
end
