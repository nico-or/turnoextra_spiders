# frozen_string_literal: true

# Flexo's Games store spider
class FlexogamesSpider < EcommerceEngines::Shopify::Spider
  @name = "flexogames_spider"
  @store = {
    name: "Flexo's Games",
    url: "https://www.flexogames.cl/"
  }
  @start_urls = ["https://www.flexogames.cl/collections/juegos-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "div#Collection ul.grid li",
      next_page: "ul.pagination li:last-child a"
    }
  )

  selector :title, "a span"
  selector :price, "dl span.price-item"
  selector :stock, "dl.price--sold-out"
end
