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
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("div#Collection ul.grid li")
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
    next_page_node = response.at_css("ul.pagination li:last-child a")
    return unless next_page_node

    absolute_url(next_page_node[:href], base: url)
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

  def purchasable?(node)
    in_stock?(node)
  end

  # TODO: This store loads product images lazily.
  # The data-srcset attribute is not immediately available when using the Mechanize engine.
  # It doesn't work with SeleniumChrome either. We need to find a way to trigger the image load.
  def get_image_url(_node)
    nil
  end
end
