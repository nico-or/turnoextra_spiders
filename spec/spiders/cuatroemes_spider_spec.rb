# frozen_string_literal: true

require "spider_helper"

RSpec.describe CuatroemesSpider, :spider, engine: :jumpseller do
  let(:fixture_directory) { "cuatroemes" }
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
          url: "https://www.cuatroemes.cl/tapple-el-juego-de-palabras-mas-rapido",
          title: "Tapple - El juego de palabras más rápido.",
          price: 29_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/cuatroemes/image/62600926"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.cuatroemes.cl/encontremonos-navidad",
          title: "Encontrémonos - Navidad",
          price: 9_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/cuatroemes/image/54005017"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an options index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_options.html") }

      let(:expected) do
        {
          url: "https://www.cuatroemes.cl/the-academic-133-xl-copiar",
          title: "Portamazo Stronghold 200+ Convertible",
          price: 44_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/cuatroemes/image/48106954"
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
        expected = "https://www.cuatroemes.cl/tienda?page=2"
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
