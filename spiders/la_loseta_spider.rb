# frozen_string_literal: true

# La Loseta store spider
class LaLosetaSpider < EcommerceEngines::WooCommerce::Spider
  @name = "la_loseta_spider"
  @store = {
    name: "La Loseta",
    url: "https://laloseta.cl/"
  }
  @start_urls = ["https://laloseta.cl/catalogo/swoof1/product_cat-juego-de-mesa/instock/"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser
  )

  image_url_strategy(:sized)
end
