# frozen_string_literal: true

# Topo Token store spider
# Engine: woocommerce
class TopoTokenSpider < ApplicationSpider
  @name = "topo_token_spider"
  @store = {
    name: "Topo Token",
    url: "https://topotoken.cl"
  }
  @start_urls = ["https://topotoken.cl/tienda"]
  @config = {}

  def parse(response, url:, data: {})
    parse_index(response)
    paginate(response, url)
  end

  # Parse a Nokogiri::Element and call #parse_product_node on all elements
  def parse_index(response, url: nil, data: {})
    nodes = response.css("ul.products li.product")
    nodes.each { |node| parse_product_node(node) }
  end

  # Parse a Nokogiri::Element representing a listing and call #send_item on it
  def parse_product_node(node)
    item = {}
    item[:url] = get_url(node)
    item[:title] = get_title(node)
    item[:price] = get_price(node)
    item[:stock] = in_stock?(node)
    item[:image_url] = get_image_url(node)

    send_item item
  end

  private

  def paginate(response, url)
    next_page = response.at_css("nav.woocommerce-pagination li a.next")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def get_url(node)
    node.at_css("a")[:href]
  end

  def get_title(node)
    node.at_css("h2").text
  end

  def get_price(node)
    price_node = node.css("span.price bdi").last
    scan_int(price_node.text) if price_node
  end

  def in_stock?(node)
    # Store lists password protected private products, likely ad-hoc listings for individual imports
    !node.classes.include?("post-password-required")
  end

  def get_image_url(node)
    # matches an url like: "https://topotoken.cl/wp-content/uploads/2024/11/BOTCT-Box-3D-2-300x300.png"
    regex = /(?<url>.*)(?<size>-\d+x\d+)(?<ext>\..*)/

    full_url = node.at_css("img")["src"]
    match = full_url.match(regex)

    "#{match[:url]}#{match[:ext]}"
  rescue NoMethodError
    nil
  end
end
