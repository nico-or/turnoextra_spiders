# frozen_string_literal: true

# Piedrabruja store spider
# This store serves malformed HTML.
# Many tags aren't closed properly, which causes each listing node to include all subsequent nodes.
# Thus it's necessary to use only #at_css to find the first tag that matches the selector.
# This also causes that we can't easily drop the empty placeholders nodes at the end of the listings array.
class PiedrabrujaSpider < EcommerceEngines::Shopify::Spider
  @name = "piedrabruja_spider"
  @store = {
    name: "piedrabruja",
    url: "https://www.piedrabruja.cl/"
  }
  @start_urls = ["https://piedrabruja.cl/collections/juegos-de-mesa?page=1"]
  @config = {}

  @index_parser_factory = ParserFactory.new(
    Base::ProductIndexPageParser,
    selectors: {
      index_product: "div.product-list div.product-item",
      next_page: "div.pagination a[@rel=next]"
    }
  )

  selector :title, "a.product-item__title"

  private

  def regular_price(node)
    node.at_css("span.price")
  end

  def discount_price(node)
    node.at_css("span.price--highlight")
  end

  def get_price(node)
    price_node = discount_price(node) || regular_price(node)
    return unless price_node

    scan_int(price_node.children.last.text)
  end

  def in_stock?(_node)
    true
  end
end
