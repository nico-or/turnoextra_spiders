# frozen_string_literal: true

# La Guarida Del Dragon store spider
class LaGuaridaDelDragonSpider < ApplicationSpider
  @name = "la_guarida_del_dragon_spider"
  @store = {
    name: "La Guarida Del Dragon",
    url: "https://www.laguaridadeldragon.cl/"
  }
  @start_urls = [
    "https://www.laguaridadeldragon.cl/collection/juegos",
    "https://www.laguaridadeldragon.cl/collection/miniaturas"
  ]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Bsale::ProductCardParser
  )
end
