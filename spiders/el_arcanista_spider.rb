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

  selector :url, "a.product-name"
  selector :title, "a.product-name"
  selector :price, "span.item-price"
  selector :stock, "span.badge-sold"
  selector :image_attr, "data-src"
end
