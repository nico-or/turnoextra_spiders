# frozen_string_literal: true

require "spider_helper"

RSpec.describe OvniplaySpider, :spider, engine: :jumpseller do
  let(:fixture_directory) { "ovniplay" }
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
          url: "https://www.ovniplay.cl/dixit-revelations-juego-de-mesa-espanol",
          title: "Dixit: Expasión Revelations - Español",
          price: 19_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/ovniplay/image/36199799"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.ovniplay.cl/blood-on-the-clocktower-espanol",
          title: "Blood on the Clocktower - Español",
          price: 170_990,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/ovniplay/image/62323870"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.ovniplay.cl/so-clover-espanol",
          title: "So Clover! - Español",
          price: 19_990,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/ovniplay/image/36200820"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an unavailable index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_unavailable.html") }

      let(:expected) do
        {
          url: "https://www.ovniplay.cl/preventa-zombicide-white-death-espanol-expansion-independiente",
          title: "Preventa - Zombicide White Death - Español (Expansión independiente)",
          price: 53_995,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/ovniplay/image/40017459"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an options index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_options.html") }

      let(:expected) do
        {
          url: "https://www.ovniplay.cl/preventa-sniper-elite-el-juego-de-tablero",
          title: "Preventa - Sniper Elite: El juego de tablero",
          price: 38_995,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/ovniplay/image/62187575"
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
        expected = "https://www.ovniplay.cl/juegos-de-mesa?page=2"
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
