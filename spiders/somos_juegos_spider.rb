# frozen_string_literal: true

# Somos Juegos store spider
class SomosJuegosSpider < EcommerceEngines::Shopify::Spider
  @name = "somos_juegos_spider"
  @store = {
    name: "Somos Juegos",
    url: "https://www.somosjuegos.cl"
  }
  @start_urls = ["https://www.somosjuegos.cl/collections/juegos-de-mesa"]
  @config = {}

  def parse_index(response, url:, data: {})
    super(response, url:, data:, selector: "div#filter-results ul.grid li.js-pagination-result")
  end

  def next_page_url(response, url)
    super(response, url, "nav ul.pagination li:last-child a")
  end

  private

  def get_title(node)
    super(node, "p a")
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
