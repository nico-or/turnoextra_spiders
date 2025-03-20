# frozen_string_literal: true

# Devir store spider
class DevirSpider < ApplicationSpider
  @name = "devir_spider"
  @store = {
    name: "Devir",
    url: "https://www.devir.cl/"
  }
  @start_urls = ["https://devir.cl/juegos-de-mesa?p=1"]
  @config = {}

  def parse(response, url:, data: {})
    response.css("div.products li.item").each do |listing|
      parse_product_node(listing)
    end

    paginate(response, url)
  end

  def paginate(response, url)
    next_page = response.at_css('a[title="Siguiente"]')
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  def parse_product_node(node)
    item = {}
    item[:url] = node.at_css("strong a")[:href]
    item[:title] = node.at_css("strong a").text.strip
    # The price element is mising for out-of-stock products
    price_node = node.at_css("span.price")
    item[:price] = price_node.nil? ? 0 : price_node.text.match(/([\d.]+),/)[1].gsub(".", "")
    item[:stock] = in_stock(node)

    send_item item
  end

  def button_text(node)
    node.css("div.actions-primary").text.strip
  end

  def in_stock(node)
    button_text(node).eql?("Añadir al carrito")
  end
end
