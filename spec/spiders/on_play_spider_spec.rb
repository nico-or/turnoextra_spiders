# frozen_string_literal: true

require "spider_helper"

RSpec.describe OnPlaySpider do
  let(:fixture_directory) { "on_play" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 12 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(12)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://onplaygames.cl/producto/dd-el-tesoro-de-los-dragones-de-fizban/",
          title: "D&D El Tesoro de los Dragones de Fizban",
          price: 54_990,
          stock: true,
          image_url: "https://onplaygames.cl/wp-content/uploads/2025/11/el-tesoro-de-los-dragones-de-fizban-dd-600x600-1.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://onplaygames.cl/producto/autumn/",
          title: "Autumn",
          price: 7_990,
          stock: true,
          image_url: "https://onplaygames.cl/wp-content/uploads/2025/11/8436589627635-1200-face3d.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://onplaygames.cl/producto/dd-caja-de-inicio-los-dragones-de-la-isla-de-las-tempestades/",
          title: "D&D Caja de Inicio Los Dragones de la Isla de las Tempestades",
          price: 39990,
          stock: false,
          image_url: "https://onplaygames.cl/wp-content/uploads/2025/11/Artboard418.webp"
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
    context "with an index page that has a next page link" do
      let(:response) do
        html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
        Nokogiri::HTML(html)
      end

      it "has a next page" do
        actual = spider.next_page_url(response, store_url)
        expected = "https://onplaygames.cl/categoria-producto/juego-de-mesa/page/2/"
        expect(actual).to eq(expected)
      end
    end

    context "with an index page that hasn't a next page link" do
      let(:response) do
        html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_false.html"))
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
