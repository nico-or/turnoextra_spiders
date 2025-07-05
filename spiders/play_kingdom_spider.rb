# frozen_string_literal: true

# Play Kingdom store spider
class PlayKingdomSpider < EcommerceEngines::Jumpseller::Spider
  @name = "play_kingdom_spider"
  @store = {
    name: "Play Kingdom",
    url: "https://playkingdom.cl"
  }
  @start_urls = ["https://playkingdom.cl/juegos-de-mesa"]
  @config = {}

  selector :index_product, "article.product-block"
  selector :next_page, "ul.pager li.next a"
  selector :title, "a.product-block__name"
  selector :price, "div.product-block__price"
  selector :url, "a"
  selector :stock, "div.product-block__label--status"
  selector :image_split, "thumb"
end
