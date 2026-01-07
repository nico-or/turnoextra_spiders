# frozen_string_literal: true

require 'support/parsers_helper'

RSpec.describe Helpers do
  let(:base_url) { "https://example.com/" }

  describe ".absolute_url" do
    context "when href is already percent-encoded" do
      let(:href) { "/path/to/product-%C2%BA-name" }

      it "does not double-encode the URL" do
        result = described_class.absolute_url(href, base_url:)
        expect(result).to eq("https://example.com/path/to/product-%C2%BA-name")
      end
    end
  end
end
