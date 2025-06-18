# frozen_string_literal: true

# La Fortaleza store spider
class LaFortalezaSpider < EcommerceEngines::Jumpseller::Spider
  @name = "la_fortaleza_spider"
  @store = {
    name: "La Fortaleza",
    url: "https://www.lafortalezapuq.cl"
  }
  @start_urls = ["https://www.lafortalezapuq.cl/jdm"]
  @config = {}

  def parse_index(response, url:, data: {})
    listings = response.css("div.products figure.product")
    listings.map { |listing| parse_product_node(listing, url:) }
  end

  def next_page_url(response, url)
    next_page_node = response.at_css("nav.pagination-next-prev a[@class=next]")
    return unless next_page_node

    absolute_url(next_page_node[:href], base: url)
  end

  private

  def get_title(node)
    node.at_css("h5").text
  end

  def discount_price(node)
    node.at_css("span.product-price-discount i")
  end

  def regular_price(node)
    node.at_css("span.product-price")
  end

  def get_price(node)
    price_node = discount_price(node) || regular_price(node)
    scan_int(price_node.text) if price_node
  end

  def in_stock?(node)
    node.at_css("div.product-out-of-stock").nil?
  end

  def get_image_url(node)
    super(node, "thumb")
  end
end
