# frozen_string_literal: true

require "support/parsers_helper"

RSpec.describe EcommerceEngines::WooCommerce::ProductCardParser do
  let(:base_url) { "https://www.example.com" }

  let(:parser) do
    html = File.read(fixture)
    node = Nokogiri::HTML.fragment(html).children.first
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

  context "with a product with src image and in stock" do
    let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/woo_commerce/product_card_src.html" }

    let(:expected) do
      {
        url: "https://carontejuegosdemesa.cl/producto/no-gracias/",
        title: "¡No Gracias!",
        price: 12_990,
        stock: true,
        image_url: "https://carontejuegosdemesa.cl/wp-content/uploads/2022/09/No-Gracias.jpg"
      }
    end

    it "returns the correct product" do
      expect(result).to eq(expected)
    end
  end

  context "with a product with srcset image and out of stock" do
    let(:fixture) { "spec/fixtures/parsers/ecommerce_engines/woo_commerce/product_card_srcset.html" }

    let(:expected) do
      {
        url: "https://carontejuegosdemesa.cl/producto/no-gracias/",
        title: "¡No Gracias!",
        price: 12_990,
        stock: false,
        image_url: "https://carontejuegosdemesa.cl/wp-content/uploads/2022/09/No-Gracias.jpg"
      }
    end

    it "returns the correct product" do
      expect(result).to eq(expected)
    end
  end
end
