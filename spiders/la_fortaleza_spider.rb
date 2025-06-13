# frozen_string_literal: true

# La Fortaleza store spider
# engine: jumpseller
class LaFortalezaSpider < ApplicationSpider
  @name = "la_fortaleza_spider"
  @store = {
    name: "La Fortaleza",
    url: "https://www.lafortalezapuq.cl"
  }
  @start_urls = ["https://www.lafortalezapuq.cl/jdm"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    nodes = response.css("div.products figure.product")
    nodes.map { |node| parse_product_node(node, url:) }
  end

  def parse_product_node(node, url:)
    {
      url: get_url(node, url),
      title: get_title(node),
      price: get_price(node),
      stock: purchasable?(node),
      image_url: get_image_url(node)
    }
  end

  def next_page_url(response, url)
    next_page_node = response.at_css("nav.pagination-next-prev a[@class=next]")
    return unless next_page_node

    absolute_url(next_page_node[:href], base: url)
  end

  private

  def paginate(response, url)
    next_url = next_page_url(response, url)
    request_to(:parse, url: next_url) if next_url
  end

  def get_url(node, url)
    rel_url = node.at_css("a")[:href]
    absolute_url(rel_url, base: url)
  end

  def get_title(node)
    node.at_css("h5").text
  end

  def get_price(node)
    discount_node = node.at_css("span.product-price-discount i")
    regular_node = node.at_css("span.product-price")
    price_node = discount_node || regular_node
    scan_int(price_node.text) if price_node
  end

  def in_stock?(node)
    node.at_css("div.product-out-of-stock").nil?
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def get_image_url(node)
    # example: https://cdnx.jumpseller.com/la-fortaleza-punta-arenas1/image/13909331/thumb/230/260?1610821805
    node.at_css("img")[:src]&.split("/thumb")&.first
  rescue NoMethodError
    nil
  end
end
