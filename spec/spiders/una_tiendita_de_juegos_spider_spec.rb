# frozen_string_literal: true

require "spider_helper"

RSpec.describe UnaTienditaDeJuegosSpider, :spider, engine: :jumpseller do
  let(:fixture_directory) { "una_tiendita_de_juegos" }
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
          url: "https://www.unatienditadejuegos.cl/7-wonders-nueva-edicion",
          title: "7 Wonders - nueva edición",
          price: 45_500,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/una-tiendita-de-juegos/image/29491563"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.unatienditadejuegos.cl/gift-card-virtual-50000",
          title: "Gift Card virtual $50.000",
          price: 45_000,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/una-tiendita-de-juegos/image/58105498"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.unatienditadejuegos.cl/zombies-tercera-edicion",
          title: "Zombies!!! Tercera Edición",
          price: 23_500,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/una-tiendita-de-juegos/image/29462237"
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
        expected = "https://www.unatienditadejuegos.cl/todos?page=2"
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
