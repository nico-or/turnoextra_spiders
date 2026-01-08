# frozen_string_literal: true

# Juegos Gori store spider
class JuegosGoriSpider < ApplicationSpider
  @name = "juegos_gori_spider"
  @store = {
    name: "Juegos Gori",
    url: "https://www.juegosgori.cl/"
  }
  @start_urls = ["https://www.juegosgori.cl/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser,
    selectors: {
      # rubocop:disable Layout/LineLength
      price: ".//div[contains(@class,'product-block__price')]//span[contains(@class,'product-block__price--discount')]/text()
      | .//div[contains(@class,'product-block__price')][not(.//span[contains(@class,'product-block__price--discount')])]/text()"
      # rubocop:enable Layout/LineLength
    }
  )
end
