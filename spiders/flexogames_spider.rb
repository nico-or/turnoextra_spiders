# frozen_string_literal: true

# Flexo's Games store spider
# Engine: shopify
class FlexogamesSpider < ApplicationSpider
  @name = "flexogames_spider"
  @store = {
    name: "Flexo's Games",
    url: "https://www.flexogames.cl/"
  }
  @start_urls = ["https://www.flexogames.cl/collections/juegos-de-mesa"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response, url: url)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("div#Collection ul.grid li")
    listings.each { parse_product_node(it, url) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node, url)
    item = {}
    item[:url] = get_url(node, url)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = in_stock?(node)
    # item[:image_url] = get_image_url(node)

    send_item item
  end

  def paginate(response, url)
    next_page = response.at_css("ul.pagination li:last-child a")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_url(node, url)
    absolute_url(node.at_css("a")[:href], base: url)
  end

  def get_title(node)
    node.at_css("a span").text
  end

  def get_price(node)
    # there are multiple span.price-item, the 1st one seems to always
    # reflect the price regardless of any discounts
    price_node = node.css("dl span.price-item").first
    scan_int(price_node&.text)
  end

  def in_stock?(node)
    node.css("dl.price--sold-out").empty?
  end

  # TODO: This store loads product images lazily.
  # The data-srcset attribute is not immediately available when using the Mechanize engine.
  # It doesn't work with SeleniumChrome either. We need to find a way to trigger the image load.
  #
  # def get_image_url(node)
  #   url = node.at_css("img")["data-srcset"].split.first
  #   uri = URI.parse(url)
  #   uri.query = nil
  #   uri.scheme = "https"
  #   uri.path = uri.path.sub(/_\d+x/, "")
  #   uri.to_s
  # end
end
