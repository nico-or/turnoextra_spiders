# frozen_string_literal: true

# El Calabozo store spider
class ElCalabozoSpider < ApplicationSpider
  @name = "el_calabozo_spider"
  @store = {
    name: "El Calabozo",
    url: "https://www.calabozotienda.cl/"
  }
  @start_urls = ["https://www.calabozotienda.cl/tienda/familia/JUEGOS%20DE%20MESA"]

  @index_parser_factory = ParserFactory.new(
    Stores::ElCalabozo::ProductIndexPageParser
  )

  selector :title, "div.card-body p.card-text span:first-child"
  selector :url, "a"
  selector :price, "div.card-body p.card-text strong:last-of-type span"
  selector :stock, "span.badge-danger"
  selector :image_url, "img"

  private

  def get_image_url(node, _url)
    node.at_css("img")["src"]
  end
end
