# frozen_string_literal: true

# Base class for Store spiders
class ApplicationSpider < Tanakai::Base
  include ApplicationHelper

  @engine = :mechanize
  @pipelines = %i[formatter validator saver]

  @config = {
    user_agent: "TurnoExtraBot/1.0 (+https://turnoextra.cl/contact) Ruby/#{RUBY_VERSION} Tanakai/#{Tanakai::VERSION}",
    disable_images: true,
    skip_duplicate_requests: true,
    skip_request_errors: [{ error: RuntimeError, message: "404 => Net::HTTPNotFound" }],
    retry_request_errors: [Net::ReadTimeout, Net::HTTPTooManyRequests],
    before_request: {
      delay: 2
    }
  }

  class << self
    attr_reader :store

    def selectors
      @selectors ||= {}
    end

    def selector(key, selector)
      selectors[key] = selector
    end

    def inherited(subclass)
      super
      subclass.instance_variable_set(
        :@selectors,
        selectors.dup
      )
    end
  end

  def get_selector(key)
    self.class.selectors[key] || raise(KeyError, "Missing selector for: #{key}")
  end

  def parse(response, url:, data: {})
    items = parse_index(response, url:, data:)
    items.each { |item| send_item item }

    paginate(response, url)
  end

  def parse_index(response, url:, data: {})
    selector = get_selector(:index_product)
    listings = response.css(selector)
    listings.map { |listing| parse_product_node(listing, url:) }
  end

  def next_page_url(response, url)
    selector = get_selector(:next_page)
    next_page_node = response.at_css(selector)
    return unless next_page_node

    absolute_url(next_page_node[:href], base: url)
  end

  def parse_product_node(node, url:)
    {
      url: get_url(node, url),
      title: get_title(node),
      price: get_price(node),
      stock: purchasable?(node),
      image_url: get_image_url(node, url)
    }
  end

  private

  def paginate(response, url)
    next_page_url = next_page_url(response, url)
    request_to(:parse, url: next_page_url) if next_page_url
  end

  def get_url(node, url = nil)
    selector = get_selector(:url)
    rel_url = node.at_css(selector)["href"]
    absolute_url(rel_url, base: url)
  end

  def get_title(node)
    selector = get_selector(:title)
    raw_text = node.at_css(selector)&.text || ""
    sanitized = raw_text.encode("UTF-8", invalid: :replace, undef: :replace, replace: "")
    sanitized.gsub(/\s+/, " ").strip
  end

  def get_price(node)
    selector = get_selector(:price)
    price_node = node.at_css(selector)
    return unless price_node

    scan_int(price_node.text)
  end

  def in_stock?(node)
    selector = get_selector(:stock)
    node.at_css(selector).nil?
  end

  def purchasable?(node)
    in_stock?(node)
  end

  def absolute_url(rel_url, base:)
    uri = Addressable::URI.parse(rel_url).normalize
    URI.join(base, uri).to_s
  end
end
