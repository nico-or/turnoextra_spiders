# frozen_string_literal: true

# Devir store spider
# engine: ??
class DevirSpider < ApplicationSpider
  @name = "devir_spider"
  @store = {
    name: "Devir",
    url: "https://www.devir.cl/"
  }
  @start_urls = ["https://devir.cl/juegos-de-mesa?p=1"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("div.products li.item")

    listings.map { |listing| parse_product_node(listing, url:) }
  end

  def parse_product_node(node, url:)
    {
      url: get_url(node),
      title: get_title(node),
      price: get_price(node),
      stock: purchasable?(node),
      image_url: get_image_url(node)
    }
  end

  def next_page_url(response, url)
    next_page = response.at_css('a[title="Siguiente"]')
    return unless next_page

    absolute_url(next_page[:href], base: url)
  end

  private

  def paginate(response, url)
    next_url = next_page_url(response, url)
    request_to(:parse, url: next_url) if next_url
  end

  def in_stock?(node)
    # check the presence of the add to cart form
    node.at_css("form")&.attr("data-role") == "tocart-form"
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def get_url(node)
    node.at_css("strong a")[:href]
  end

  def get_title(node)
    node.at_css("strong a").text.strip
  end

  def get_price(node)
    price_node = node.at_css("span.price")
    return unless price_node

    # Example text: 12.990,00 CLP
    clean_price_text = price_node.text.split(",00").first.strip
    scan_int(clean_price_text)
  end

  def get_image_url(node)
    node.at_css("img.product-image-photo")[:src]
  rescue NoMethodError
    nil
  end
end
