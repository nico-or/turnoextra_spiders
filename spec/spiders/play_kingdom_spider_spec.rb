# frozen_string_literal: true

require "spider_helper"

RSpec.describe PlayKingdomSpider do
  let(:fixture_directory) { "play_kingdom" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 30 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(30)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://playkingdom.cl/la-tripulacion-en-busqueda-del-noveno-planeta",
          title: "La Tripulacion - En busqueda del noveno planeta",
          price: 14_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/play-kingdom/image/30353600"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://playkingdom.cl/lacrimosa",
          title: "Lacrimosa",
          price: 45_490,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/play-kingdom/image/30152818"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://playkingdom.cl/juego-de-mesa-mascarade-nueva-edicion",
          title: "Mascarade Nueva Edicion",
          price: 18_990,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/play-kingdom/image/29939341"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an unavailable index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_unavailable.html") }

      let(:expected) do
        {
          url: "https://playkingdom.cl/mojate-el-potito",
          title: "Mójate el potito",
          price: 14_990,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/play-kingdom/image/29939227"
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
        expected = "https://playkingdom.cl/juegos-de-mesa?page=2"
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
