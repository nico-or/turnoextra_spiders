# frozen_string_literal: true

module EcommerceEngines
  module Shopify
    # Base spider class for all stores build with Shopify
    class Spider < ApplicationSpider
      @config = {
        before_request: {
          delay: 8..10
        }
      }
    end
  end
end
