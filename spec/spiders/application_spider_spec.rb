# frozen_string_literal: true

require "spider_helper"

RSpec.describe ApplicationSpider do
  let(:spider) { described_class.new }
  let(:base_url) { "https://example.com/" }

  before do
    described_class.selector(:url, "a")
  end

  describe "#absolute_url" do
    context "when href is already percent-encoded" do
      let(:href) { "/path/to/product-%C2%BA-name" }

      it "does not double-encode the URL" do
        result = spider.send(:absolute_url, href, base: base_url)
        expect(result).to eq("https://example.com/path/to/product-%C2%BA-name")
      end
    end
  end
end
