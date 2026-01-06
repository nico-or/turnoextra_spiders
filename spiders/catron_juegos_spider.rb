# frozen_string_literal: true

# Catron Juegos store spider
class CatronJuegosSpider < EcommerceEngines::Jumpseller::Spider
  @name = "catron_juegos_spider"
  @store = {
    name: "Catron Juegos",
    url: "https://www.catronjuegos.cl/"
  }
  @start_urls = ["https://www.catronjuegos.cl/juegos-de-interior/de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  selector :stock, "div.product-block__actions > a"
end
