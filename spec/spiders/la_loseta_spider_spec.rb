# frozen_string_literal: true

require "spider_helper"

RSpec.describe LaLosetaSpider, :spider, engine: :woocommerce do
  let(:fixture_directory) { "la_loseta" }
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
          url: "https://laloseta.cl/product/aventureros-al-tren-india-y-suiza/",
          title: "¡Aventureros al Tren! India y Suiza",
          price: 31_990,
          stock: true,
          image_url: "https://laloseta.cl/wp-content/uploads/woocommerce-placeholder.png"
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
          url: "https://laloseta.cl/product/zombie-kittens/",
          title: "ZOMBIE KITTENS",
          price: 19_990,
          stock: false,
          image_url: "https://laloseta.cl/wp-content/uploads/2025/05/ZOMBIEKITTENS.webp"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a price-ranged index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_price_range.html") }

      let(:expected) do
        {
          url: "https://laloseta.cl/product/evoluciones-prismaticas-coleccion-super-premium/",
          title: "Pokemon TCG – Evoluciones Prismaticas – Colección Super Premium",
          price: 149_990,
          stock: true,
          image_url: "https://laloseta.cl/wp-content/uploads/2025/05/pokemonsuperpremiumcollection1.png"
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
        expected = "https://laloseta.cl/product-category/juego-de-mesa/page/2/"
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
