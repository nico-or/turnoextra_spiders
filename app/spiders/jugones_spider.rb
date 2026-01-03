# frozen_string_literal: true

# Jugones store spider
class JugonesSpider < ApplicationSpider
  @name = "jugones_spider"
  @store = {
    name: "Jugones",
    url: "https://www.jugones.cl/"
  }
  @start_urls = ["https://www.jugones.cl/juegos-de-mesa"]

  selector :index_product, "div.producto"
  selector :title, "a.modelo"
  selector :url, "a.modelo"
  selector :stock, "a.precio.reserva"

  # TODO: prevent method argument test from forcing rubocop magic comments
  def next_page_url(response, url) # rubocop:disable Lint/UnusedMethodArgument
    nil
  end

  private

  def regular_price(node)
    node.at_css("a.precio")&.children&.[](0)
  end

  def discount_price(node)
    node.at_css("a.precio.oferta")&.children&.[](2)
  end

  def get_price(node)
    price_node = discount_price(node) || regular_price(node)
    scan_int(price_node&.text)
  end

  def get_image_url(node, url)
    # Example: https://www.jugones.cl/img/cache/140x140_100_172828401616969534121681488307wow1.jpg
    rel_url = node.at_css("img[src]")&.attr("src")
    return unless rel_url

    rel_url.sub!(%r{cache/\d+x\d+_\d+_}, "productos/")
    absolute_url(rel_url, base: url)
  end
end
