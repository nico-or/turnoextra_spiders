# frozen_string_literal: true

# El Arcanista store spider
class ElArcanistaSpider < EcommerceEngines::Shopify::Spider
  @name = "el_arcanista_spider"
  @store = {
    name: "El Arcanista",
    url: "https://elarcanista.cl/"
  }
  @start_urls = [
    "https://elarcanista.cl/collections/famliy-games",
    "https://elarcanista.cl/collections/party-games"
  ]

  @index_parser_factory = ParserFactory.new(
    Stores::ElArcanista::ProductIndexPageParser
  )
  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Shopify::ProductCardParser,
    selectors: {
      url: "a.product-name",
      title: "a.product-name",
      price: "span.item-price",
      stock: "span.badge-sold",
      image_attr: "data-src"
    }
  )
end
