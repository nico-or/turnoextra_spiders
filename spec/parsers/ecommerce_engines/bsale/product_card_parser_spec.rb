# frozen_string_literal: true

require "support/parsers_helper"

RSpec.describe EcommerceEngines::Bsale::ProductCardParser do
  let(:base_url) { "https://www.example.com" }

  let(:parser) do
    html = File.read(fixture)
    node = Nokogiri::HTML5.parse(html)
    described_class.new(node, base_url:)
  end

  let(:result) do
    {
      url: parser.url,
      title: parser.title,
      price: parser.price,
      stock: parser.purchasable?,
      image_url: parser.image_url
    }
  end

  context "with a product with regular price" do
    let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/bsale/product_card_regular.html" }

    let(:expected) do
      {
        url: "#{base_url}/product/monopoly-stranger-things",
        title: "Monopoly Stranger Things",
        price: 33_990,
        stock: true,
        image_url: "https://dojiw2m9tvv09.cloudfront.net/93109/product/M_descarga-49361.jpg"
      }
    end

    it "returns the correct product" do
      expect(result).to eq(expected)
    end
  end

  context "with a product with discounted price" do
    let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/bsale/product_card_discounted.html" }

    let(:expected) do
      {
        url: "#{base_url}/product/yu-gi-oh-structure-deck-blue-eyes-white-destiny-ingles",
        title: "Yu-Gi-Oh!: Structure Deck Blue-Eyes White Destiny - Inglés",
        price: 13_590,
        stock: true,
        image_url: "https://dojiw2m9tvv09.cloudfront.net/93109/product/M_sdwd-decken3818.png"
      }
    end

    it "returns the correct product" do
      expect(result).to eq(expected)
    end
  end
end
