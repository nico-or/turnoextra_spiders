# frozen_string_literal: true

# El Desafio Store store spider
class ElDesafioStoreSpider < EcommerceEngines::WooCommerce::Spider
  @name = "el_desafio_store_spider"
  @store = {
    name: "El Desafio Store",
    url: "https://eldesafiostore.cl/"
  }
  @start_urls = ["https://eldesafiostore.cl/tienda/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "div.products div.product"
    }
  )

  selector :title, "h3"

  image_url_strategy(:sized)
end
