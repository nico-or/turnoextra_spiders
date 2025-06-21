# frozen_string_literal: true

# Tienda Card Game store spider
class TiendaCardGameSpider < EcommerceEngines::Shopify::Spider
  @name = "tienda_card_game_spider"
  @store = {
    name: "Tienda Card Game",
    url: "https://www.cardgame.cl/"
  }
  @start_urls = ["https://www.cardgame.cl/collections/juegos-de-mesa"]
  @config = {}

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
