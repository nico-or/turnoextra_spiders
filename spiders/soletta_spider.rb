# frozen_string_literal: true

# Soletta store spider
class SolettaSpider < EcommerceEngines::Bsale::Spider
  @name = "soletta_spider"
  @store = {
    name: "Soletta",
    url: "https://www.soletta.cl/"
  }
  @start_urls = ["https://www.soletta.cl/collection/todos"]

  @index_parser_factory = ParserFactory.new(
    Stores::Soletta::ProductIndexPageParser
  )

  selector :title, "h2"
  selector :stock, "div.bs-stock"
  selector :price, "div.bs-product-final-price"
  selector :image_attr, "data-src"
end
