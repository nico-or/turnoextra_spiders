# frozen_string_literal: true

require "support/parsers_helper"

RSpec.describe EcommerceEngines::Shopify::ProductCardParser do
  let(:base_url) { "https://www.example.com" }

  let(:selectors) { {} }

  let(:parser) do
    html = File.read(fixture)
    node = Nokogiri::HTML5.parse(html)
    described_class.new(node, base_url:, selectors:)
  end

  let(:result) do
    {
      url: parser.url,
      image_url: parser.image_url
    }
  end

  context "with a regular product card" do
    let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/shopify/product_card_regular.html" }
    let(:expected) do
      {
        url: "#{base_url}/products/donde-las-papas-queman",
        image_url: "https://area52.cl/cdn/shop/files/2.png"
      }
    end

    it "returns the correct product" do
      expect(result).to eq(expected)
    end
  end

  context "with a product card with lazy images" do
    let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/shopify/product_card_lazy.html" }
    let(:selectors) { { image_tag: "noscript img" } }
    let(:expected) do
      {
        url: "#{base_url}/collections/todos-los-juegos/products/barbecubes",
        image_url: "https://chileboardgames.com/cdn/shop/files/barbecubes_195x195@2x.png"
      }
    end

    it "returns the correct product" do
      expect(result).to eq(expected)
    end
  end

  context "with a custom product card" do
    let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/shopify/product_card_custom.html" }
    let(:selectors) { { image_tag: "img", image_attr: "data-src" } }
    let(:expected) do
      {
        url: "#{base_url}/collections/todos-los-juegos-de-mesa/products/rifa-de-verano-enroque-ganate-un-ano-de-juegos-de-mesa",
        image_url: "https://juegosenroque.cl/cdn/shop/files/rifa2.png"
      }
    end

    it "returns the correct product" do
      expect(result).to eq(expected)
    end
  end
end
