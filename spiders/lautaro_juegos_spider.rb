# frozen_string_literal: true

# Lautaro Juegos store spider
class LautaroJuegosSpider < EcommerceEngines::Jumpseller::Spider
  @name = "lautaro_juegos_spider"
  @store = {
    name: "Lautaro Juegos",
    url: "https://www.lautarojuegos.cl/"
  }
  @start_urls = ["https://www.lautarojuegos.cl/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser,
    selectors: {
      next_page: "div.category-pager a:last-child[href]"
    }
  )

  selector :stock, "a.not-available"
  selector :image_split, "resize"

  private

  def get_title(node)
    node.at_css("img")[:alt].strip
  end

  def regular_price(node)
    node.at_css("div.list-price span.product-block-list")
  end

  def discount_price(node)
    node.at_css("div.list-price span.product-block-normal")
  end

  def get_price(node)
    price_node = discount_price(node) || regular_price(node)
    return unless price_node

    scan_int(price_node.text)
  end
end
