# frozen_string_literal: true

# El Patio Geek store spider
# Engine: shopify
class ElPatioGeekSpider < ApplicationSpider
  @name = "el_patio_geek_spider"
  @store = {
    name: "El Patio Geek",
    url: "https://www.elpatiogeek.cl/"
  }
  @start_urls = ["https://www.elpatiogeek.cl/collections/all"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("div.grid-uniform div.grid-item")
    listings.map { |listing| parse_product_node(listing, url:) }
  end

  def parse_product_node(node, url:)
    {
      url: get_url(node, url),
      title: get_title(node),
      price: get_price(node),
      stock: purchasable?(node),
      image_url: get_image_url(node, url)
    }
  end

  def next_page_url(response, url)
    next_page = response.at_css("ul.pagination-custom li:last-child a")
    return unless next_page

    absolute_url(next_page[:href], base: url)
  end

  private

  def paginate(response, url)
    next_page_url = next_page_url(response, url)
    request_to(:parse, url: next_page_url) if next_page_url
  end

  def get_url(node, url)
    absolute_url(node.at_css("a")[:href], base: url)
  end

  def get_title(node)
    node.at_css("p").text
  end

  def get_price(node)
    price_node = node.at_css("div.product-item--price small")
    scan_int(price_node&.text)
  end

  def purchasable?(_node)
    true
  end

  def get_image_url(node, url)
    image_url = node.at_css("img")["srcset"].split[-2]
    absolute_url(image_url, base: url).then do |url|
      uri = URI.parse(url)
      uri.query = nil
      uri.to_s
    end
  rescue NoMethodError
    nil
  end
end
