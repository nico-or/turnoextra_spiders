# frozen_string_literal: true

require "spider_helper"

RSpec.describe VortexJuegosSpider, :spider, engine: :woocommerce do
  let(:fixture_directory) { "vortex_juegos" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 12 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(12)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://vortexjuegos.cl/producto/bienvenido-de-nuevo-a-la-mazmorra/",
          title: "BIENVENIDO DE NUEVO A LA MAZMORRA",
          price: 12_990,
          stock: true,
          image_url: "https://vortexjuegos.cl/wp-content/uploads/2024/10/BIENVENIDO-DE-NUEVO-A-LA-MAZMORRA.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://vortexjuegos.cl/producto/producto/",
          title: "PROTECTORES STD.CARD USA",
          price: 3_000,
          stock: true,
          image_url: "https://vortexjuegos.cl/wp-content/uploads/2024/08/1000055719.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://vortexjuegos.cl/producto/aventureros-al-tren-san-francisco/",
          title: "¡AVENTUREROS AL TREN! SAN FRANCISCO",
          price: 14_990,
          stock: false,
          image_url: "https://vortexjuegos.cl/wp-content/uploads/2024/10/¡AVENTUREROS-AL-TREN-SAN-FRANCISCO.png"
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
        expected = "https://vortexjuegos.cl/tienda/page/2/?filter_stock_status=instock"
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
