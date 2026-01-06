# frozen_string_literal: true

# On Play store spider
class OnPlaySpider < EcommerceEngines::WooCommerce::Spider
  @name = "on_play_spider"
  @store = {
    name: "On Play",
    url: "https://onplaygames.cl/"
  }

  @start_urls = ["https://onplaygames.cl/categoria-producto/juego-de-mesa/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      next_page: "nav.ct-pagination a[rel=next]"
    }
  )

  image_url_strategy(:sized)
end
