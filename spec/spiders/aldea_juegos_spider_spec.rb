# frozen_string_literal: true

require "spider_helper"

RSpec.describe AldeaJuegosSpider do
  let(:fixture_directory) { "aldea_juegos" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 50 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(50)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.aldeajuegos.cl/altered/5220-torneo-altered-susurros-del-laberinto-14-de-junio-.html",
          title: "torneo altered susurros del laberinto 14 de junio",
          price: 6_000,
          stock: true,
          image_url: "https://www.aldeajuegos.cl/10032-large_default/torneo-altered-susurros-del-laberinto-14-de-junio.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.aldeajuegos.cl/familiar/4036-wizard-724373627809.html",
          title: "wizard",
          price: 11_042,
          stock: true,
          image_url: "https://www.aldeajuegos.cl/7817-large_default/wizard.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.aldeajuegos.cl/familiar/5155-maravillas-del-mundo-.html",
          title: "maravillas del mundo",
          price: 59_990,
          stock: false,
          image_url: "https://www.aldeajuegos.cl/9932-large_default/maravillas-del-mundo.jpg"
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
        expected = "https://www.aldeajuegos.cl/7-juegos-de-mesa?page=2"
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
