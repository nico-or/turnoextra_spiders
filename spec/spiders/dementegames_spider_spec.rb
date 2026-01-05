# frozen_string_literal: true

require "spider_helper"

RSpec.describe DementegamesSpider, :spider, engine: :prestashop do
  let(:fixture_directory) { "dementegames" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 48 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(48)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://dementegames.cl/familiares/5663-yo-soy-tu-peli.html",
          title: "Yo Soy Tu Peli",
          price: 19_990,
          stock: true,
          image_url: "https://dementegames.cl/19601-large_default/yo-soy-tu-peli.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://dementegames.cl/rapidos/5608-yokai-pagoda.html",
          title: "Yokai Pagoda",
          price: 18_041,
          stock: true,
          image_url: "https://dementegames.cl/19321-large_default/yokai-pagoda.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://dementegames.cl/cooperativos/5607-frostpunk-dreadnought-expansion.html",
          title: "Frostpunk: Dreadnought Expansion",
          price: 54_141,
          stock: false,
          image_url: "https://dementegames.cl/19313-large_default/frostpunk-dreadnought-expansion.jpg"
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
        expected = "https://dementegames.cl/10-juegos-de-mesa?page=2&q=Disponibilidad-Inmediata/Existencias-En+stock"
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
