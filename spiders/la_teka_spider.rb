# frozen_string_literal: true

# La Teka store spider
class LaTekaSpider < EcommerceEngines::Shopify::Spider
  @name = "la_teka_spider"
  @store = {
    name: "La Teka",
    url: "https://lateka.cl"
  }
  @start_urls = ["https://lateka.cl/collections/juegos-de-mesa?filter.v.availability=1"]
  @config = {}

  def parse_index(response, url:, data: {})
    super(response, url:, data:, selector: "ul#product-grid div.card")
  end

  def next_page_url(response, url)
    # yes, the store has backward styles for next and prev links...
    super(response, url, "nav.pagination a.pagination__item--prev")
  end

  private

  def get_title(node)
    super(node, "h3")
  end

  def get_price(node)
    super(node, "span.price-item--sale")
  end

  def in_stock?(node)
    super(node, "product-form button[disabled]")
  end

  def get_image_url(node)
    url = node.at_css("img")["src"]
    format_image_url(url)
  rescue NoMethodError
    nil
  end
end
