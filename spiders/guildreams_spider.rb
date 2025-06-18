# frozen_string_literal: true

# Guildreams store spider
class GuildreamsSpider < EcommerceEngines::Bsale::Spider
  @name = "guildreams_spider"
  @store = {
    name: "Guildreams",
    url: "https://www.guildreams.com"
  }
  @start_urls = ["https://www.guildreams.com/collection/juegos-de-mesa?order=id&way=DESC&limit=24&page=1"]
  @config = {}

  def parse_index(response, url:, data: {})
    super(response, url:, selector: "div.bs-product")
  end

  def next_page_url(response, url)
    super(response, url, "ul.pagination li:last-child a.page-link[data-nf]")
  end

  private

  def get_title(node)
    node.at_css("h2").text.strip
  end

  def get_price(node)
    super(node, "div.bs-product-final-price")
  end

  def in_stock?(node)
    super(node, "div.bs-stock")
  end

  def get_image_url(node)
    super(node, "data-src")
  end
end
