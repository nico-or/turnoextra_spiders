# frozen_string_literal: true

# Gamehouse Coyhaique store spider
class GamehouseCoyhaiqueSpider < EcommerceEngines::Bsale::Spider
  @name = "gamehouse_coyhaique_spider"
  @store = {
    name: "Gamehouse Coyhaique",
    url: "https://www.gamehousecoyhaique.cl/"
  }
  @start_urls = ["https://www.gamehousecoyhaique.cl/collection/juegos-de-mesa"]

  selector :title, "h3[@class='bs-collection__product-title']/text()"
end
