# frozen_string_literal: true

# Updown store spider
class UpdownSpider < EcommerceEngines::WooCommerce::Spider
  @name = "updown_spider"
  @store = {
    name: "Updown",
    url: "https://www.updown.cl/"
  }
  @start_urls = ["https://www.updown.cl/categoria-producto/juegos-de-mesa/"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      index_product: "div.wd-products div.wd-product",
      next_page: "ul.page-numbers a.next"
    }
  )

  selector :title, "h3"

  image_url_strategy(:srcset)
end
