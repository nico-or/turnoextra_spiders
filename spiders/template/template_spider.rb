# frozen_string_literal: true

# Template store spider
# Engine: ??
class TemplateSpider < ApplicationSpider
  @name = "template_spider"
  @store = {
    name: "template",
    url: "https://www.template.cl/"
  }
  @start_urls = ["https://www.example.com/"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    listings = response.css("")
    listings.each { parse_product_node(it) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node)
    item = {}
    item[:url] = node.at_css("")[:href]
    item[:title] = node.at_css("").text
    item[:price] = get_price(node)
    item[:stock] = in_stock(node)

    send_item item
  end

  private

  def paginate(response, url)
    next_page = response.at_css("")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_price(node)
    price_node = node.at_css("")
    price_text = price_node.text
    scan_int(price_text)
  end

  def in_stock?(_node)
    true
  end
end
