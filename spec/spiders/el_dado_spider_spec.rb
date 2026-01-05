# frozen_string_literal: true

require "spider_helper"

RSpec.describe ElDadoSpider, :spider, engine: :woocommerce do
  let(:fixture_directory) { "el_dado" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 16 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(16)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://eldado.cl/producto/zombicide-angry-neighbors/",
          title: "Zombicide Angry Neighbors",
          price: 55_990,
          stock: true,
          image_url: "https://eldado.cl/wp-content/uploads/2024/07/3054-Zombicide-Angry-Neighbors.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node",
            skip: "no listings were in discount at the time of writting" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "",
          title: "",
          price: 0,
          stock: true,
          image_url: ""
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://eldado.cl/producto/kodem-tcg-esp-eng/",
          title: "Kodem TCG (Inglés)",
          price: 22_990,
          stock: false,
          image_url: "https://eldado.cl/wp-content/uploads/2024/07/3132-Kodem-TCG-Ingles.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an unavailable index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_unavailable.html") }

      let(:expected) do
        {
          url: "https://eldado.cl/producto/dobble-31-minutos/",
          title: "Dobble 31 Minutos",
          price: nil,
          stock: false,
          image_url: "https://eldado.cl/wp-content/uploads/2024/12/DOBBLE-31-MINUTOS.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an price ranged index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_price_range.html") }

      let(:expected) do
        {
          url: "https://eldado.cl/producto/tarjeta-de-regalo-2/",
          title: "Tarjeta de regalo",
          price: 100_000,
          stock: true,
          image_url: "https://eldado.cl/wp-content/uploads/2024/09/pw-gift-card.png"
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
        expected = "https://eldado.cl/catalogo-de-juegos/page/2/"
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
