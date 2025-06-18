# frozen_string_literal: true

# Enroque store spider
class EnroqueSpider < EcommerceEngines::Shopify::Spider
  @name = "enroque_spider"
  @store = {
    name: "enroque",
    url: "https://www.juegosenroque.cl/"
  }
  @start_urls = [
    "https://www.juegosenroque.cl/collections/todos-los-juegos-de-mesa",
    "https://www.juegosenroque.cl/collections/preventas",
    "https://www.juegosenroque.cl/collections/ofertas"
  ]
  @config = {}

  def parse_index(response, url:, data: {})
    super(response, url:, selector: "div#filter-results li.js-pagination-result")
  end

  def next_page_url(response, url)
    super(response, url, "nav ul.pagination li:last-child a")
  end

  private

  def get_title(node)
    super(node, "a.card-link")
  end

  def get_price(node)
    super(node, "strong.price__current")
  end

  def in_stock?(node)
    super(node, "span.product-label--sold-out")
  end

  def get_image_url(node)
    url = node.at_css("img")["data-src"]
    format_image_url(url)
  rescue NoMethodError
    nil
  end
end
