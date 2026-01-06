# frozen_string_literal: true

# Juego Mania store spider
class JuegoManiaSpider < EcommerceEngines::Jumpseller::Spider
  @name = "juego_mania_spider"
  @store = {
    name: "Juego Mania",
    url: "https://www.juegomania.cl/"
  }
  @start_urls = ["https://www.juegomania.cl/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  selector :stock, "div.product-block__label--status"

  private

  def regular_price(node)
    node.at_css("div.product-block__price--new, div.product-block__price:last-child")
  end

  def discount_price(node)
    price_node = node.at_css("div.product-block__price span:first-child")
    return unless price_node

    price_node
  end

  def get_price(node)
    price_node = discount_price(node) || regular_price(node)
    return unless price_node

    scan_int(price_node.text)
  end
end
