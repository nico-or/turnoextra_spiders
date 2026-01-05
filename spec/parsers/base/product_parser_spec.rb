# frozen_string_literal: true

require "support/parsers_helper"

RSpec.describe Base::ProductParser do
  let(:html) do
    <<~HTML
      <div class='product-card'>
        <a class='link' href='/products/heavy-boots'>
          <h2 class='product-title'> Heavy Duty Boots </h2>
        </a>
        <span class='price-amount'>$12.990</span>
        <div class='out-of-stock-label' style='display:none;'>Sold Out</div>
      </div>
    HTML
  end

  let(:selectors) do
    {
      url: "a.link",
      title: ".product-title",
      price: ".price-amount",
      stock: ".out-of-stock-label"
    }
  end

  let(:base_url) { "https://www.example.com" }

  let(:parser) do
    node = Nokogiri::HTML5.parse(html).at_css(".product-card")
    described_class.new(node, base_url:, selectors:)
  end

  describe "#url" do
    it "returns the absolute product url" do
      expected = "https://www.example.com/products/heavy-boots"
      expect(parser.url).to eq(expected)
    end
  end

  describe "#title" do
    it "returns the cleaned text of the title" do
      expect(parser.title).to eq("Heavy Duty Boots")
    end

    it "returns an empty string if title node is missing" do
      allow(parser.node).to receive(:at_css).with(".product-title").and_return(nil)
      expect(parser.title).to eq("")
    end
  end

  describe "#price" do
    it "extracts the integer value from the price text" do
      expect(parser.price).to eq(12_990)
    end

    it "returns nil if price node is missing" do
      allow(parser.node).to receive(:at_css).with(".price-amount").and_return(nil)
      expect(parser.price).to be_nil
    end
  end

  describe "#stock?" do
    context "when the stock selector is NOT found" do
      let(:html) { "<div class='product-card'></div>" } # No '.out-of-stock-label'

      it "returns true (assumed in stock)" do
        expect(parser.stock?).to be true
      end
    end

    context "when the stock selector IS found" do
      it "returns false (out of stock)" do
        expect(parser.stock?).to be false
      end
    end
  end

  describe "#purchasable?" do
    it "returns the same value as stock?" do
      expect(parser.purchasable?).to eq(parser.stock?)
    end
  end
end
