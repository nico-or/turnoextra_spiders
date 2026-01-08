# frozen_string_literal: true

# Ovniplay store spider
class OvniplaySpider < ApplicationSpider
  @name = "ovniplay_spider"
  @store = {
    name: "Ovniplay",
    url: "https://www.ovniplay.cl"
  }
  @start_urls = ["https://www.ovniplay.cl/juegos-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductCardParser,
    selectors: {
      # rubocop:disable Layout/LineLength
      price: ".//div[contains(@class,'product-block__price')]//span[contains(@class,'product-block__price--discount')]/text()
      | .//div[contains(@class,'product-block__price')][not(.//span[contains(@class,'product-block__price--discount')])]/text()[normalize-space()]",
      # rubocop:enable Layout/LineLength
      stock: "span.badge.unavailable"
    }
  )
end
