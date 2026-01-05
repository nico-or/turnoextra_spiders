require "support/parsers_helper"

RSpec.describe EcommerceEngines::Bsale::ProductIndexPageParser do
  let(:base_url) { "https://www.bluecard.cl" }

  before do
    html = File.read(fixture)
    node = Nokogiri::HTML5.parse(html)
    @parser = described_class.new(node, base_url:)
  end

  describe "#product_nodes" do
    context "with the first page" do
      let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/bsale/product_index_page_paginate_true.html" }

      it "returns 12 nodes" do
        expect(@parser.product_nodes.length).to eq(12)
      end
    end
  end

  describe "#next_page" do
    context "with the first page" do
      let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/bsale/product_index_page_paginate_true.html" }

      it "returns the next page url" do
        expected = "https://www.bluecard.cl/collection/juegos-de-mesa?order=price&way=ASC&limit=12&page=2"
        expect(@parser.next_page_url).to eq(expected)
      end
    end

    context "with the last page" do
      let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/bsale/product_index_page_paginate_false.html" }

      it "returns nil" do
        expected = nil
        expect(@parser.next_page_url).to eq(expected)
      end
    end
  end
end
