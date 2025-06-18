# frozen_string_literal: true

# VuduGaming store spider
class VudugamingSpider < EcommerceEngines::Jumpseller::Spider
  @name = "vudugaming_spider"
  @store = {
    name: "VuduGaming",
    url: "https://www.vudugaming.cl/"
  }
  @start_urls = ["https://www.vudugaming.cl/juegos-de-mesa"]
  @config = {}

  def parse_index(response, url:, data: {})
    listings = response.css("article.product-block")
    listings.map { |listing| parse_product_node(listing, url:) }
  end

  def next_page_url(response, url)
    next_page = response.at_css("ul.pager li.next a")
    return unless next_page

    absolute_url(next_page[:href], base: url)
  end

  private

  def get_title(node)
    node.at_css("h2").text.strip
  end

  def get_price(node)
    price_node = node.at_css("div.product-block__price")
    scan_int(price_node.text)
  end

  def in_stock?(node)
    !node.at_css(".product-block__actions form").nil?
  end

  def get_image_url(node)
    super(node, "resize")
  end
end
