# frozen_string_literal: true

module Base
  class LegacyProductParser
    attr_reader :node, :base_url, :spider

    def initialize(node, base_url:, spider:)
      @node = node
      @base_url = base_url
      @spider = spider

      deprecation_warning!
    end

    def url
      spider.send(:get_url, node, base_url)
    end

    def title
      spider.send(:get_title, node)
    end

    def price
      spider.send(:get_price, node)
    end

    def image_url
      spider.send(:get_image_url, node, base_url)
    end

    def purchasable?
      spider.send(:purchasable?, node)
    end

    private

    def deprecation_warning!
      return if ENV["TANAKAI_ENV"] == "production"

      warn "[Deprecated] #{spider.class} is using #{self.class}"
    end
  end
end
