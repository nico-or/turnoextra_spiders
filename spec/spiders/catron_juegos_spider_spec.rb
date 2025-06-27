# frozen_string_literal: true

require "spider_helper"

RSpec.describe CatronJuegosSpider do
  let(:fixture_directory) { "catron_juegos" }
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
          url: "https://www.catronjuegos.cl/el-solitario",
          title: "El Solitario",
          price: 2_100,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/catron-juegos-y-pasatiempos/image/13409391"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.catronjuegos.cl/set-4-conos-lenteja-franklin",
          title: "Set 4 Conos Lenteja Franklin",
          price: 6_990,
          stock: true,
          image_url: "https://cdnx.jumpseller.com/catron-juegos-y-pasatiempos/image/30063257"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.catronjuegos.cl/rumino",
          title: "Ruminó",
          price: 8_500,
          stock: false,
          image_url: "https://cdnx.jumpseller.com/catron-juegos-y-pasatiempos/image/51465666"
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
        expected = "https://www.catronjuegos.cl/juegos-de-interior/de-mesa?page=2"
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
