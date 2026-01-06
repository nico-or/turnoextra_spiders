# frozen_string_literal: true

# Por Eso Estoy Pobre store spider
class PorEsoEstoyPobreSpider < EcommerceEngines::Shopify::Spider
  @name = "por_eso_estoy_pobre_spider"
  @store = {
    name: "Por Eso Estoy Pobre",
    url: "https://poresoestoypobre.cl/"
  }
  @start_urls = ["https://poresoestoypobre.cl/collections/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "ul#product-grid > li",
      next_page: "link[rel=next]"
    }
  )

  selector :title, "h3 a"
  selector :price, "div.price__regular span.price-item--regular"
  selector :stock, "div.price--sold-out"
end
