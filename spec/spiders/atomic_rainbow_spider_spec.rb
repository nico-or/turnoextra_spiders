# frozen_string_literal: true

require "spider_helper"

RSpec.describe AtomicRainbowSpider do
  let(:fixture_directory) { "atomic_rainbow" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 40 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(40)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.atomicrainbow.cl/aventureros-al-tren",
          title: "¡AVENTUREROS AL TREN!",
          price: 44_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/atomic-rainbow/image/45174376"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.atomicrainbow.cl/the-red-cathdral-contractors",
          title: "THE RED CATHDRAL: CONTRACTORS",
          price: 19_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/atomic-rainbow/image/62452174"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.atomicrainbow.cl/a-prueba-de-retos",
          title: "¡A PRUEBA DE RETOS!",
          price: 24_990,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/atomic-rainbow/image/53136793"
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
        expected = "https://www.atomicrainbow.cl/juego-de-mesa?page=2"
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
