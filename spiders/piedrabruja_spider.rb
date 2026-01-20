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
      index_product: "motion-list div.card",
      next_page: "div.pagination a.next"
    }
  )

  @product_parser_factory = ParserFactory.new(
    EcommerceEngines::Shopify::ProductCardParser,
    selectors: {
      title: "a.product-card__title",
      price: "span.price__regular"
    }
  )
end
