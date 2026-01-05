# frozen_string_literal: true

require "spider_helper"

RSpec.describe LaMafiaJuegosSpider, :spider, engine: :woocommerce do
  let(:fixture_directory) { "la_mafia_juegos" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 6 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(6)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://lamafiajuegos.cl/producto/quien-fue-juego-de-mesa/",
          title: "¿Quién fue?",
          price: 11_990,
          stock: true,
          image_url: "https://lamafiajuegos.cl/wp-content/uploads/2025/08/1.jpg.webp"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://lamafiajuegos.cl/producto/juego-de-mesa-7-wonders/",
          title: "7 Wonders",
          price: 45_990,
          stock: true,
          image_url: "https://lamafiajuegos.cl/wp-content/uploads/2025/10/7-wonders-nueva-edicion-promo.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://lamafiajuegos.cl/producto/juego-catan-el-despertar-de-la-humanidad/",
          title: "Catan: El Despertar de la Humanidad",
          price: 49_990,
          stock: false,
          image_url: "https://lamafiajuegos.cl/wp-content/uploads/2025/08/Mesa-de-trabajo27615.webp"
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
        expected = "https://lamafiajuegos.cl/shop/page/2/"
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
