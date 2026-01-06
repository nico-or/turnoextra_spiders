# frozen_string_literal: true

# Chile Board Games store spider
class ChileBoardGamesSpider < EcommerceEngines::Shopify::Spider
  @name = "chile_board_games_spider"
  @store = {
    name: "Chile Board Games",
    url: "https://chileboardgames.com/"
  }
  @start_urls = ["https://chileboardgames.com/collections/todos-los-juegos"]

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
  selector :image_attr, "srcset"
end
