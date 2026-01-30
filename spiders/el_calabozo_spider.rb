# frozen_string_literal: true

# El Calabozo store spider
class ElCalabozoSpider < ApplicationSpider
  @name = "el_calabozo_spider"
  @store = {
    name: "El Calabozo",
    url: "https://www.calabozotienda.cl/"
  }
  @start_urls = ["https://www.calabozotienda.cl/tienda/familia/JUEGOS%20DE%20MESA"]

  @index_parser_factory = ParserFactory.new(
    Stores::ElCalabozo::ProductIndexPageParser
  )

  @product_parser_factory = ParserFactory.new(
    Base::ProductParser,
    selectors: {
      title: "div.card-body p.card-text span:first-child",
      url: "a",
      price: "div.card-body p.card-text strong:last-of-type span",
      stock: "span.badge-danger",
      image_tag: "img",
      image_attr: "src"
    }
  )
end
