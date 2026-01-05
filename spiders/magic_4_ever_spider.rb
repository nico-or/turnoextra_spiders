# frozen_string_literal: true

# Magic 4 Ever store spider
class Magic4EverSpider < EcommerceEngines::Jumpseller::Spider
  @name = "magic_4_ever_spider"
  @store = {
    name: "Magic 4 Ever",
    url: "https://www.m4e.cl/"
  }
  @start_urls = ["https://www.m4e.cl/juegos-de-mesa"]

  selector :next_page, "div.category-pager a:last-child[href]"
  selector :price, "div.price span.block-price"
  selector :stock, "a.btn.gray"

  private

  def get_title(node)
    node.at_css("img")[:title].strip
  end
end
