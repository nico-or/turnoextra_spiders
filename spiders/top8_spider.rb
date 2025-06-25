# frozen_string_literal: true

# Top8 store spider
class Top8Spider < EcommerceEngines::Bsale::Spider
  @name = "top8_spider"
  @store = {
    name: "Top8",
    url: "https://www.top8.cl"
  }

  # Clicking 'show all' doesn't show all games,
  # so we need to crawl each collection individually
  @start_urls = [
    "https://www.top8.cl/collection/juegos-de-mesa",
    "https://www.top8.cl/collection/jm-eurogames",
    "https://www.top8.cl/collection/jm-party-games",
    "https://www.top8.cl/collection/jm-deck-building",
    "https://www.top8.cl/collection/jm-infantiles",
    "https://www.top8.cl/collection/jm-draft",
    "https://www.top8.cl/collection/jm-fillers",
    "https://www.top8.cl/collection/jm-cooperativos",
    "https://www.top8.cl/collection/jm-rol",
    "https://www.top8.cl/collection/dungeons-dragons"
  ]
  @config = {}

  selector :index_product, "div.bs-collection section.grid__item"
  selector :next_page, "ul.pagination li:last-child a"
  selector :title,  "h3.bs-collection__product-title"
  selector :stock,  "div.bs-collection__stock"
  selector :price,  "div.bs-collection__product-final-price"
  selector :url, "a"
  selector :image_tag, "img"
  selector :image_attr, "src"
end
