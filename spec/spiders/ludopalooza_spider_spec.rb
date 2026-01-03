# frozen_string_literal: true

require "spider_helper"

RSpec.describe LudopaloozaSpider do
  let(:fixture_directory) { "ludopalooza" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 24 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(24)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://ludopalooza.cl/products/alice-ha-desaparecido",
          title: "Alice ha Desaparecido",
          price: 20_000,
          stock: true,
          image_url: "https://ludopalooza.cl/cdn/shop/files/AlicehaDesaparecido.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://ludopalooza.cl/products/la-polilla-tramposa",
          title: "La Polilla Tramposa",
          price: 14_990,
          stock: true,
          image_url: "https://ludopalooza.cl/cdn/shop/files/IMG_2901.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://ludopalooza.cl/products/31-minutos-dobble",
          title: "31 Minutos - Dobble",
          price: 15_990,
          stock: false,
          image_url: "https://ludopalooza.cl/cdn/shop/files/dobble-31-minutos-juego31minutosjuegodemesa.jpg"
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
        expected = "https://ludopalooza.cl/collections/all?page=2&phcursor=eyJhbGciOiJIUzI1NiJ9.eyJzayI6InByb2R1Y3RfdGl0bGUiLCJzdiI6IkRvYmJsZSBjbMOhc2ljbyIsImQiOiJmIiwidWlkIjo4Nzc2NTA0OTAxODU2LCJsIjoyNCwibyI6MCwiciI6IkNQIiwidiI6MX0.Wj_IU1nP238JyxM-v3dtFZYgFJac4LHNE-ku57iyizQ"
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
