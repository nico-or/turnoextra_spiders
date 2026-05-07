# frozen_string_literal: true

require "spider_helper"

RSpec.describe LaPosadaDelDadoSpider, :spider, engine: :shopify do
  let(:fixture_directory) { "la_posada_del_dado" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 24 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(24)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://laposadadeldado.cl/products/rcg-random-card-generator?variant=44197486035135",
          title: "RCG: Random Card Generator",
          price: 14_990,
          stock: true,
          image_url: "https://laposadadeldado.cl/cdn/shop/files/rcg.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://laposadadeldado.cl/products/tank-up?variant=44197487542463",
          title: "Tank Up!",
          price: 29_990,
          stock: true,
          image_url: "https://laposadadeldado.cl/cdn/shop/files/Diseno_sin_titulo_7.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://laposadadeldado.cl/products/cards-vs-gravity?variant=44510829052095",
          title: "Cards vs Gravity",
          price: 17_990,
          stock: false,
          image_url: "https://laposadadeldado.cl/cdn/shop/files/LaPosadadeldado_25_bf83e660-2e4f-413b-940c-143eabe1f82b.jpg"
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
        expected = "https://laposadadeldado.cl/collections/juegos-de-mesa?page=2"
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
