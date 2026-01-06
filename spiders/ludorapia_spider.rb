# frozen_string_literal: true

# Ludorapia store spider
class LudorapiaSpider < EcommerceEngines::Jumpseller::Spider
  @name = "ludorapia_spider"
  @store = {
    name: "Ludorapia",
    url: "https://ludorapia.jumpseller.com/"
  }
  @start_urls = ["https://ludorapia.jumpseller.com/juegos-de-mesa"]

  @index_parser_factory = ParserFactory.new(
    EcommerceEngines::Jumpseller::ProductIndexPageParser,
  )

  private

  def regular_price(node)
    node.at_css("div.product-block__price")
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
