# frozen_string_literal: true

# El Calabozo store spider
class ElCalabozoSpider < ApplicationSpider
  @name = "el_calabozo_spider"
  @store = {
    name: "El Calabozo",
    url: "https://www.calabozotienda.cl/"
  }
  @start_urls = ["https://www.calabozotienda.cl/tienda/familia/JUEGOS%20DE%20MESA"]

  selector :index_product, "div.Prod-item"
  selector :next_page, "li.page-item.active + li.d-none a"

  selector :title, "div.card-body p.card-text span:first-child"
  selector :url, "a"
  selector :price, "div.card-body p.card-text strong:last-of-type span"
  selector :stock, "span.badge-danger"
  selector :image_url, "img"

  def next_page_url(response, url) # rubocop:disable Lint/UnusedMethodArgument
    selector = get_selector(:next_page)
    next_page_node = response.at_css(selector)
    return unless next_page_node

    Addressable::URI.parse(next_page_node[:href]).normalize.to_s
  end

  private

  def get_image_url(node, _url)
    node.at_css("img")["src"]
  end
end
