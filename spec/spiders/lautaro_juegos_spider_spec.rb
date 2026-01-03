# frozen_string_literal: true

require "spider_helper"

RSpec.describe LautaroJuegosSpider do
  let(:fixture_directory) { "lautaro_juegos" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 36 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(36)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.lautarojuegos.cl/sherlock-far-west-disparos-al-amanecer",
          title: "Sherlock Far West Disparos al amanecer",
          price: 7_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/lautaro-juegos/image/59285136"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.lautarojuegos.cl/los-tesoros-del-rey-pirata-2o-edicion",
          title: "Los Tesoros del Rey Pirata (2º edición)",
          price: 17_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/lautaro-juegos/image/19855872"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.lautarojuegos.cl/vaca-loca",
          title: "Vaca Loca",
          price: 9_990,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/lautaro-juegos/image/15192094"
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
        expected = "https://www.lautarojuegos.cl/juegos-de-mesa?page=2"
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
