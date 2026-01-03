# frozen_string_literal: true

require "spider_helper"

RSpec.describe DmesaSpider do
  let(:fixture_directory) { "dmesa" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 18 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(18)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.dmesa.cl/product/no-lo-testeamos-ni-un-poco/",
          title: "No Lo Testeamos Ni Un Poco",
          price: 12_990,
          stock: true,
          image_url: "https://www.dmesa.cl/wp-content/uploads/2023/01/no-lo-testeamos-ni-un-poco.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.dmesa.cl/product/marvel-united-el-ascenso-de-black-panther-espanol/",
          title: "Marvel United: El ascenso de Black Panther (Español)",
          price: 19_990,
          stock: true,
          image_url: "https://www.dmesa.cl/wp-content/uploads/2022/03/juegos_de_mesa_marvel_united_black_panther_dmesa.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a pack price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_pack.html") }

      let(:expected) do
        {
          url: "https://www.dmesa.cl/product/pack-oferta-al-seco-amigos-de-mierda/",
          title: "Pack Oferta: Amigos de Mierda + Al Seco",
          price: 20_990,
          stock: false,
          image_url: "https://www.dmesa.cl/wp-content/uploads/2024/08/15605929732-1.png"
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
    context "with an index page that has a next page link" do
      let(:response) do
        html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
        Nokogiri::HTML(html)
      end

      it "has a next page" do
        actual = spider.next_page_url(response, store_url)
        expected = "https://www.dmesa.cl/product-category/juegos-de-mesa/page/2/"
        expect(actual).to eq(expected)
      end
    end

    context "with an index page that hasn't a next page link" do
      let(:response) do
        html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_false.html"))
        Nokogiri::HTML(html)
      end

      it "has no next page" do
        actual = spider.next_page_url(response, store_url)
        expected = nil
        expect(actual).to eq(expected)
      end
    end
  end
end
