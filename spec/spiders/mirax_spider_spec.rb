# frozen_string_literal: true

require "spider_helper"

RSpec.describe MiraxSpider, :spider, engine: :custom do
  let(:fixture_directory) { "mirax" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 90 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(90)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.mirax.cl/detalles.php?codigo=288682",
          title: "DEVIR BLO TULIO LULO LANA TARRO PATANA 31 MINUTOS",
          price: 14_990,
          stock: true,
          image_url: "https://www.mirax.cl/productos/n280001a290000/n288001a289000/n288601a288700/m288682.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node",
            skip: "no listings were in discount at the time of writting" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "",
          title: "",
          price: 0,
          stock: true,
          image_url: ""
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.mirax.cl/detalles.php?codigo=291502",
          title: "THINKFUN 44007351 ESCAPE THE ROOM STARGAZER",
          price: nil,
          stock: false,
          image_url: "https://www.mirax.cl/productos/n290001a300000/n291001a292000/n291501a291600/m291502.jpg"
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
        expected = "https://www.mirax.cl/buscadorx.php?categoria=705&pagina=1"
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
