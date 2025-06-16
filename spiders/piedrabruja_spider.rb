# frozen_string_literal: true

# Piedrabruja store spider
# Engine: shopify
#
# This store serves malformed HTML.
# Many tags aren't closed properly, which causes each listing node to include all subsequent nodes.
# Thus it's necessary to use only #at_css to find the first tag that matches the selector.
# This also causes that we can't easily drop the empty placeholders nodes at the end of the listings array.
#
class PiedrabrujaSpider < ApplicationSpider
  @name = "piedrabruja_spider"
  @store = {
    name: "piedrabruja",
    url: "https://www.piedrabruja.cl/"
  }
  @start_urls = ["https://piedrabruja.cl/collections/juegos-de-mesa?page=1"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("ul#collection li.product-card")
    listings.map { |listing| parse_product_node(listing, url:) }
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
    next_page = response.css("a").find { it.text.include?("más productos") }
    return unless next_page

    absolute_url(next_page[:href], base: url)
  end

  private

  def paginate(response, url)
    next_page_url = next_page_url(response, url)
    request_to(:parse, url: next_page_url) if next_page_url
  end

  def get_url(node, url)
    absolute_url(node.at_css("h3 a")[:href], base: url)
  end

  def get_title(node)
    node.at_css("h3").text.strip
  end

  def get_price(node)
    price_node = node.at_css("p.price").children.last
    scan_int(price_node.text)
  end

  def in_stock?(_node)
    true
  end

  def purchasable?(node)
    in_stock?(node)
  end

  # Since the store has empty nodes at the end of the HTML,
  # we need to rescue from errors when trying to access the :src attribute.
  def get_image_url(node)
    url = node.at_css("img")["src"]
    uri = URI.parse(url)
    uri.scheme = "https"
    uri.query = nil
    uri.to_s
  rescue NoMethodError
    nil
  end
end
