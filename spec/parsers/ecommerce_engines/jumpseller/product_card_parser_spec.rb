# frozen_string_literal: true

require "support/parsers_helper"

RSpec.describe EcommerceEngines::Jumpseller::ProductCardParser do
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

  context "with a product card with default jumpseller style" do
    let(:base_url) { "https://www.example.com" }

    context "with a product with regular price" do
      let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/jumpseller/product_card_regular_1.html" }

      let(:expected) do
        {
          url: "#{base_url}/exit-muerte-en-el-oriente-express",
          title: "Exit: Muerte en el oriente Express",
          price: 14_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/juegos-del-bosque/image/65188001"
        }
      end

      it "returns the correct product" do
        expect(result).to eq(expected)
      end
    end

    context "with a product with discounted price" do
      let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/jumpseller/product_card_discounted_1.html" }

      let(:expected) do
        {
          url: "#{base_url}/7-wonders-duel",
          title: "7 Wonders Duel",
          price: 22_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/juegos-del-bosque/image/47245817"
        }
      end

      it "returns the correct product" do
        expect(result).to eq(expected)
      end
    end
  end

  context "with a product card with alternative jumpseller style" do
    let(:base_url) { "https://www.example.com" }

    context "with a product with regular price" do
      let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/jumpseller/product_card_regular_2.html" }

      let(:expected) do
        {
          url: "#{base_url}/alebrijes",
          title: "ALEBRIJES",
          price: 14_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/atomic-rainbow/image/70816439"
        }
      end

      it "returns the correct product" do
        expect(result).to eq(expected)
      end
    end

    context "with a product with discounted price" do
      let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/jumpseller/product_card_discounted_2.html" }

      let(:expected) do
        {
          url: "#{base_url}/arte-moderno",
          title: "ARTE MODERNO",
          price: 19_992,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/atomic-rainbow/image/42811066"
        }
      end

      it "returns the correct product" do
        expect(result).to eq(expected)
      end
    end
  end
end
