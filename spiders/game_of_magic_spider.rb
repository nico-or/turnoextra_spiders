# frozen_string_literal: true

# Game of Magic store spider
class GameOfMagicSpider < EcommerceEngines::Bsale::Spider
  @name = "game_of_magic_spider"
  @store = {
    name: "Game of Magic",
    url: "https://www.gameofmagictienda.cl"
  }

  @start_urls = [
    "https://www.gameofmagictienda.cl/collection/juegos-de-mesa",
    "https://www.gameofmagictienda.cl/collection/preventa-juegos-de-mesa"
  ]
  @config = {}

  selector :index_product, "div.bs-collection section.grid__item"
  selector :next_page, "ul.pagination li:last-child a"
  selector :title,  "a[@class='bs-collection__product-info']/h3/text()"
  selector :stock,  "div.bs-collection__stock"
  selector :price,  "div.bs-collection__product-final-price"
  selector :url, "a"
  selector :image_tag, "img"
  selector :image_attr, "src"
end
