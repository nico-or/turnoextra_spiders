# frozen_string_literal: true

require "support/parsers_helper"

RSpec.describe Base::ProductIndexPageParser do
  let(:html) do
    <<~HTML
      <html>
        <ul id='products'>
          <li class='product'>product 1</li>
          <li class='product'>product 2</li>
          <li>not a product</li>
        </ul>
        <nav class='pagination'>
          <li><a>page 1</a></li>
          <li><a rel='next' href='/products/?page=2'>page 2</a></li>
        </nav>
      </html>
    HTML
  end

  let(:selectors) do
    {
      index_product: "ul#products li.product",
      next_page: "nav.pagination a[rel=next]"
    }
  end

  let(:base_url) { "https://www.example.com" }

  let(:parser) do
    node = Nokogiri::HTML5.parse(html)
    described_class.new(node, base_url:, selectors:)
  end

  describe "#product_nodes" do
    it "returns 2 nodes" do
      result = parser.product_nodes
      expect(result.length).to eq(2)
    end
  end

  describe "#next_page_url" do
    it "returns the correct url" do
      expected = "https://www.example.com/products/?page=2"
      result = parser.next_page_url
      expect(result).to eq(expected)
    end
  end
end
