# frozen_string_literal: true

# Demente Games store spider
# engine: Prestashop
class DementegamesSpider < ApplicationSpider
  @name = "dementegames_spider"
  @store = {
    name: "Demente Games",
    url: "https://www.dementegames.cl/"
  }
  @start_urls = ["https://dementegames.cl/10-juegos-de-mesa?q=Existencias-En+stock"]
  @config = {}

  def parse(response, url:, data: {})
    items = parse_index(response, url:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    listings = response.css("div#js-product-list article")
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
    # This store doesn't disable the next page link on the last pagination result
    next_page = response.at_css("nav.pagination li a[rel=next]")
    return if next_page.nil? || next_page.classes.include?("disabled")

    absolute_url(next_page[:href], base: url)
  end

  private

  def paginate(response, url)
    next_url = next_page_url(response, url)
    request_to(:parse, url: next_url) if next_url
  end

  def get_url(node)
    node.at_css(".product-title a")[:href]
  end

  def get_title(node)
    node.at_css(".product-title").text.strip
  end

  def get_price(node)
    node.at_css("span.price")[:content].to_i
  end

  def in_stock?(node)
    node.at_css("form button")["disabled"].nil?
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def get_image_url(node)
    node.at_css("img")["data-full-size-image-url"]
  rescue NoMethodError
    nil
  end
end
