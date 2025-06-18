# frozen_string_literal: true

# Top8 store spider
class Top8Spider < EcommerceEngines::Bsale::Spider
  @name = "top8_spider"
  @store = {
    name: "Top8",
    url: "https://www.top8.cl"
  }

  # Clicking 'show all' doesn't show all games,
  # so we need to crawl each collection individually
  @start_urls = [
    "https://www.top8.cl/collection/juegos-de-mesa",
    "https://www.top8.cl/collection/jm-eurogames",
    "https://www.top8.cl/collection/jm-party-games",
    "https://www.top8.cl/collection/jm-deck-building",
    "https://www.top8.cl/collection/jm-infantiles",
    "https://www.top8.cl/collection/jm-draft",
    "https://www.top8.cl/collection/jm-fillers",
    "https://www.top8.cl/collection/jm-cooperativos",
    "https://www.top8.cl/collection/jm-rol",
    "https://www.top8.cl/collection/dungeons-dragons"
  ]
  @config = {}

  def parse_index(response, url:, data: {})
    super(response, url:, selector: "div.bs-collection section.grid__item")
  end

  def next_page_url(response, url)
    super(response, url, "ul.pagination li:last-child a")
  end

  private

  def get_title(node)
    node.at_css("a")[:title]
  end

  def get_price(node)
    super(node, "div.bs-collection__product-final-price")
  end

  def in_stock?(node)
    super(node, "div.bs-collection__stock")
  end

  def get_image_url(node)
    super(node, "src")
  end
end
