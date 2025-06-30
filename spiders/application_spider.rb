# frozen_string_literal: true

# ApplicationSpider is a default base spider class. You can set here
# default settings for all spiders inherited from ApplicationSpider.
# To generate a new spider, run: `$ tanakai generate spider spider_name`
class ApplicationSpider < Tanakai::Base
  include ApplicationHelper

  # Default engine for spiders (available engines: :mechanize, :poltergeist_phantomjs,
  # :selenium_firefox, :selenium_chrome)
  @engine = :mechanize

  # Pipelines list, by order.
  # To process item through pipelines pass item to the `send_item` method
  @pipelines = %i[formatter validator saver]

  # Default config. Set here options which are default for all spiders inherited
  # from ApplicationSpider. Child's class config will be deep merged with this one
  @config = {
    # Custom headers, format: hash. Example: { "some header" => "some value", "another header" => "another value" }
    # Works only for :mechanize and :poltergeist_phantomjs engines (Selenium doesn't allow to set/get headers)
    # headers: {},

    # Custom User Agent, format: string or lambda.
    # Use lambda if you want to rotate user agents before each run:
    # user_agent: -> { ARRAY_OF_USER_AGENTS.sample }
    # Works for all engines
    # "Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0",
    user_agent: "TurnoExtraBot/1.0 (+https://turnoextra.cl/contact) Ruby/#{RUBY_VERSION} Tanakai/#{Tanakai::VERSION}",

    # Custom cookies, format: array of hashes.
    # Format for a single cookie: { name: "cookie name", value: "cookie value", domain: ".example.com" }
    # Works for all engines
    # cookies: [],

    # If enabled, browser will ignore any https errors. It's handy while using a proxy
    # with self-signed SSL cert (for example Crawlera or Mitmproxy)
    # Also, it will allow to visit webpages with expires SSL certificate.
    # Works for all engines
    # ignore_ssl_errors: true,

    # Skip images downloading if true, works for all engines
    disable_images: true,

    # Automatically skip duplicated (already visited) urls when using `request_to` method.
    # Possible values: `true` or `hash` with options.
    # In case of `true`, all visited urls will be added to the storage's scope `:requests_urls`
    # and if url already contains in this scope, request will be skipped.
    # You can configure this setting by providing additional options as hash:
    # `skip_duplicate_requests: { scope: :custom_scope, check_only: true }`, where:
    # `scope:` - use custom scope than `:requests_urls`
    # `check_only:` - if true, then scope will be only checked for url, url will not
    # be added to the scope if scope doesn't contains it.
    # works for all drivers
    skip_duplicate_requests: true,

    # Automatically skip provided errors while requesting a page.
    # If raised error matches one of the errors in the list, then this error will be caught,
    # and request will be skipped.
    # It is a good idea to skip errors like NotFound(404), etc.
    # Format: array where elements are error classes or/and hashes. You can use hash format
    # for more flexibility: `{ error: "RuntimeError", message: "404 => Net::HTTPNotFound" }`.
    # Provided `message:` will be compared with a full error message using `String#include?`. Also
    # you can use regex instead: `{ error: "RuntimeError", message: /404|403/ }`.
    skip_request_errors: [{ error: RuntimeError, message: "404 => Net::HTTPNotFound" }],

    # Automatically retry provided errors with a few attempts while requesting a page.
    # If raised error matches one of the errors in the list, then this error will be caught
    # and the request will be processed again within a delay. There are 3 attempts:
    # first: delay 15 sec, second: delay 30 sec, third: delay 45 sec.
    # If after 3 attempts there is still an exception, then the exception will be raised.
    # It is a good idea to try to retry errros like `ReadTimeout`, `HTTPBadGateway`, etc.
    # Format: same like for `skip_request_errors` option.
    retry_request_errors: [Net::ReadTimeout, Net::HTTPTooManyRequests],

    # Perform several actions before each request:
    before_request: {
      # Global option to set delay between requests.
      # Delay can be `Integer`, `Float` or `Range` (`2..5`). In case of a range,
      # delay number will be chosen randomly for each request: `rand (2..5) # => 3`
      delay: (2..4)
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
    node.at_css(selector).text.strip
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
    URI.join(base, rel_url).to_s
  end
end
