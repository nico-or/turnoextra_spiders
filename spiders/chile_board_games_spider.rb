# frozen_string_literal: true

# Chile Board Games store spider
class ChileBoardGamesSpider < EcommerceEngines::Shopify::Spider
  @name = "chile_board_games_spider"
  @store = {
    name: "Chile Board Games",
    url: "https://chileboardgames.com/"
  }
  @start_urls = ["https://chileboardgames.com/collections/todos-los-juegos"]

  selector :index_product, "div#Collection ul.grid li"
  selector :next_page, "ul.pagination li:last-child a"
  selector :title, "a span"
  selector :price, "dl span.price-item"
  selector :stock, "dl.price--sold-out"

  private

  def get_image_url(node, _url)
    url = node.at_css("img")["srcset"].split[-2]
    format_image_url(url)
  rescue NoMethodError
    nil
  end
end
