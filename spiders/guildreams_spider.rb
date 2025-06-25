# frozen_string_literal: true

# Guildreams store spider
class GuildreamsSpider < EcommerceEngines::Bsale::Spider
  @name = "guildreams_spider"
  @store = {
    name: "Guildreams",
    url: "https://www.guildreams.com"
  }
  @start_urls = ["https://www.guildreams.com/collection/juegos-de-mesa?order=id&way=DESC&limit=24&page=1"]
  @config = {}

  selector :index_product, "div.bs-product"
  selector :next_page, "ul.pagination li:last-child a.page-link[data-nf]"
  selector :title, "h2"
  selector :stock, "div.bs-stock"
  selector :price, "div.bs-product-final-price"
  selector :image_attr, "data-src"
end
