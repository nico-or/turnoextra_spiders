# frozen_string_literal: true

require "spider_helper"

RSpec.describe AraucaniaGamingSpider do
  let(:fixture_directory) { "araucania_gaming" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 30 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(30)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://araucaniagaming.cl/tienda/a-prueba-de-retos/",
          title: "¡A Prueba de Retos!",
          price: 26_990,
          stock: true,
          image_url: "https://araucaniagaming.cl/wp-content/uploads/2024/06/JDM-A-prueba-de-retos.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://araucaniagaming.cl/tienda/carcassonne-las-apuestas-mini-expansion/",
          title: "Carcassonne: Las Apuestas (Mini Expansión)",
          price: 12_990,
          stock: true,
          image_url: "https://araucaniagaming.cl/wp-content/uploads/2023/09/sHINY-ZACIAN-Y-ZAMACENTA-14-1.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://araucaniagaming.cl/tienda/cachorritos/",
          title: "¡Cachorritos!",
          price: 19_990,
          stock: false,
          image_url: "https://araucaniagaming.cl/wp-content/uploads/2022/10/JDM-Cachorritos.png"
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
        expected = "https://araucaniagaming.cl/productos/juegosdemesa/page/2/"
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
