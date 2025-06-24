# frozen_string_literal: true

require "spider_helper"

RSpec.describe Magic4EverSpider do # rubocop:disable RSpec/SpecFilePathFormat
  let(:fixture_directory) { "magic_4_ever" }
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
          url: "https://www.m4e.cl/aventureros-al-tren-ticket-to-ride-el-primer-viaje-espanol",
          title: "Aventureros al Tren (Ticket to Ride): El Primer Viaje (Español)",
          price: 31_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/magic4ever/image/16617699"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.m4e.cl/fumanyi",
          title: "Fumanyi",
          price: 10_440,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/magic4ever/image/16610375"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.m4e.cl/puzzle-lord-of-the-rings-fellowship-of-ring-2000-piezas",
          title: "Puzzle: Lord of the Rings - Fellowship of Ring (2000 piezas)",
          price: 49_990,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/magic4ever/image/51438772"
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
        expected = "https://www.m4e.cl/juegos-de-mesa?page=2"
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
