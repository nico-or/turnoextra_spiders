# frozen_string_literal: true

# Ovniplay store spider
class OvniplaySpider < EcommerceEngines::Jumpseller::Spider
  @name = "ovniplay_spider"
  @store = {
    name: "Ovniplay",
    url: "https://www.ovniplay.cl"
  }
  @start_urls = ["https://www.ovniplay.cl/juegos-de-mesa"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser
  )

  selector :stock, "span.badge.unavailable"

  private

  def regular_price(node)
    node.at_css("div.product-block__price")
  end

  def discount_price(node)
    price_node = node.at_css("div.product-block__price > span.product-block__price--discount")
    return unless price_node

    price_node.children.first
  end

  def get_price(node)
    price_node = discount_price(node) || regular_price(node)
    return unless price_node

    scan_int(price_node.text)
  end
end
