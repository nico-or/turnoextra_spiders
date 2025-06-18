# frozen_string_literal: true

# El Patio Geek store spider
class ElPatioGeekSpider < EcommerceEngines::Shopify::Spider
  @name = "el_patio_geek_spider"
  @store = {
    name: "El Patio Geek",
    url: "https://www.elpatiogeek.cl/"
  }
  @start_urls = ["https://www.elpatiogeek.cl/collections/all"]
  @config = {}

  def parse_index(response, url:, data: {})
    super(response, url:, selector: "div.grid-uniform div.grid-item")
  end

  def next_page_url(response, url)
    super(response, url, "ul.pagination-custom li:last-child a")
  end

  private

  def get_title(node)
    super(node, "p")
  end

  def get_price(node)
    super(node, "div.product-item--price small")
  end

  def purchasable?(_node)
    true
  end

  def get_image_url(node)
    url = node.at_css("img")["srcset"].split[-2]
    format_image_url(url)
  rescue NoMethodError
    nil
  end
end
