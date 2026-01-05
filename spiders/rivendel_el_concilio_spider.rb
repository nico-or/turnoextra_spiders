# frozen_string_literal: true

# Rivendel El Concilio store spider
class RivendelElConcilioSpider < EcommerceEngines::Jumpseller::Spider
  @name = "rivendel_el_concilio_spider"
  @store = {
    name: "Rivendel El Concilio",
    url: "https://www.rivendelelconcilio.cl/"
  }
  @start_urls = ["https://www.rivendelelconcilio.cl/juegos-de-mesa"]

  selector :next_page, "div.category-pager a:last-child[href]"
  selector :price, "div.price span.block-price"
  selector :stock, "a.btn.gray"

  private

  def get_title(node)
    node.at_css("img")[:title].strip
  end
end
