# frozen_string_literal: true

require "support/parsers_helper"

RSpec.describe EcommerceEngines::Prestashop::ProductCardParser do
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

  context "with a store that does not truncate the display title" do
    let(:base_url) { "https://www.example.com" }

    context "with a discounted product out of stock" do
      let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/prestashop/product_card_none_truncated.html" }

      let(:expected) do
        {
          url: "https://dementegames.cl/cooperativos/5607-frostpunk-dreadnought-expansion.html",
          title: "Frostpunk: Dreadnought Expansion",
          price: 54_141,
          stock: true,
          image_url: "https://dementegames.cl/19313-large_default/frostpunk-dreadnought-expansion.jpg"
        }
      end

      it "returns the correct product" do
        expect(result).to eq(expected)
      end
    end
  end

  context "with a store that truncates the display title but no the img alt attribute" do
    let(:base_url) { "https://www.example.com" }

    context "with a product in stock" do
      let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/prestashop/product_card_title_truncated.html" }

      let(:expected) do
        {
          url: "https://www.aldeajuegos.cl/altered/5220-torneo-altered-susurros-del-laberinto-14-de-junio-.html",
          title: "Torneo Altered Susurros del Laberinto 14 de Junio",
          price: 6_000,
          stock: true,
          image_url: "https://www.aldeajuegos.cl/10032-large_default/torneo-altered-susurros-del-laberinto-14-de-junio.jpg"
        }
      end

      it "returns the correct product" do
        expect(result).to eq(expected)
      end
    end
  end

  context "with a store that truncates both the display title and the img alt attribute" do
    let(:base_url) { "https://www.example.com" }

    context "with a product in stock" do
      let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/prestashop/product_card_both_truncated.html" }

      let(:expected) do
        {
          url: "https://www.aldeajuegos.cl/altered/5220-torneo-altered-susurros-del-laberinto-14-de-junio-.html",
          title: "torneo altered susurros del laberinto 14 de junio",
          price: 6_000,
          stock: true,
          image_url: "https://www.aldeajuegos.cl/10032-large_default/torneo-altered-susurros-del-laberinto-14-de-junio.jpg"
        }
      end

      it "returns the correct product" do
        expect(result).to eq(expected)
      end
    end
  end
end
