# frozen_string_literal: true

# Griffin Games store spider
class GriffinGamesSpider < EcommerceEngines::WooCommerce::Spider
  @name = "griffin_games_spider"
  @store = {
    name: "Griffin Games",
    url: "https://www.griffingames.cl/"
  }
  @start_urls = ["https://www.griffingames.cl/categoria-producto/juegos-de-mesa/"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::WooCommerce::ProductIndexPageParser,
    selectors: {
      next_page: "ul.page-numbers a.next"
    }
  )

  selector :title, "h3 a"
  image_url_strategy(:sized)
end
