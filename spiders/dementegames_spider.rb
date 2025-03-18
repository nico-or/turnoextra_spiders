# frozen_string_literal: true

# Demente Games store spider
class DementegamesSpider < ApplicationSpider
  @name = "dementegames_spider"
  @start_urls = ["https://dementegames.cl/10-juegos-de-mesa?page=1&q=Disponibilidad-Inmediata/Existencias-En+stock"]
  @config = {}

  def parse(response, url:, data: {})
    response.css("div#js-product-list article").each do |article|
      parse_product_node(article)
    end

    next_page = response.at_css("nav.pagination li a[@rel=next]")
    return unless next_page

    request_to :parse, url: absolute_url(next_page[:href], base: url)
  end

  # parse a Nokogiri node and return an item
  def parse_product_node(node)
    item = {}
    item[:url] = node.at_css(".product-title a")[:href]
    item[:title] = node.at_css(".product-title").text
    item[:price] = node.at_css("span.price")[:content].to_i
    item[:stock] = true

    send_item item
  end
end
