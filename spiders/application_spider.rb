# frozen_string_literal: true

# Base class for Store spiders
class ApplicationSpider < Tanakai::Base
  include ApplicationHelper
  extend Gem::Deprecate

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
    attr_reader :store, :index_parser_factory, :product_parser_factory

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
    index_page_parser(response, base_url: url)
      .product_nodes
      .map { |node| parse_product_node(node, url:) }
  end

  def next_page_url(response, url)
    index_page_parser(response, base_url: url).next_page_url
  end

  def parse_product_node(node, url:)
    parser = product_parser(node, base_url: url)
    {
      url: parser.url,
      title: parser.title,
      price: parser.price,
      stock: parser.purchasable?,
      image_url: parser.image_url
    }
  end

  private

  def index_page_parser(node, base_url:)
    self.class.index_parser_factory.build(node, base_url:)
  end

  def product_parser(node, base_url:)
    if self.class.product_parser_factory
      self.class.product_parser_factory.build(node, base_url:)
    else
      Base::LegacyProductParser.new(node, base_url:, spider: self)
    end
  end

  def paginate(response, url)
    next_page_url = next_page_url(response, url)
    request_to(:parse, url: next_page_url) if next_page_url
  end
end
