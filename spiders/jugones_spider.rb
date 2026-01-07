# frozen_string_literal: true

# Jugones store spider
class JugonesSpider < ApplicationSpider
  @name = "jugones_spider"
  @store = {
    name: "Jugones",
    url: "https://www.jugones.cl/"
  }
  @start_urls = ["https://www.jugones.cl/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    Stores::Jugones::ProductIndexPageParser
  )

  selector :title, "a.modelo"
  selector :url, "a.modelo"
  selector :stock, "a.precio.reserva"

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
    Helpers.absolute_url(rel_url, base_url: url)
  end
end
