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
  selector :index_product, "div.row div.product-block"
  selector :next_page, "div.category-pager a:last-child[href]"
  selector :price, "div.list-price span:first-child"
  selector :url, "a"
  selector :stock, "a.btn.disabled"
  selector :image_split, "resize"

  private

  def get_title(node)
    node.at_css("h3 a")[:title]
  end
end
