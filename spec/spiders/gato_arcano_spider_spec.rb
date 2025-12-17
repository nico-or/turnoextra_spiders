# frozen_string_literal: true

require "spider_helper"

RSpec.describe GatoArcanoSpider do
  let(:fixture_directory) { "gato_arcano" }
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
          url: "https://gatoarcano.cl/product/a-prueba-de-retos/",
          title: "¡A prueba de retos!",
          price: 29_990,
          stock: true,
          image_url: "https://gatoarcano.cl/wp-content/uploads/2024/03/a-prueba-de-retos-1.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://gatoarcano.cl/product/after-the-virus/",
          title: "After the virus",
          price: 24_990,
          stock: true,
          image_url: "https://gatoarcano.cl/wp-content/uploads/2023/07/Mesa-de-trabajo27992.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a preorder price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_preorder.html") }

      let(:expected) do
        {
          url: "https://gatoarcano.cl/product/otra-vez-sopa/",
          title: "¡Otra vez sopa!",
          price: 14_990,
          stock: true,
          image_url: "https://gatoarcano.cl/wp-content/uploads/2025/09/¡OTRA-VEZ-SOPA-1.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://gatoarcano.cl/product/callate/",
          title: "¡Cállate!",
          price: 19_990,
          stock: false,
          image_url: "https://gatoarcano.cl/wp-content/uploads/2024/09/callat.jpg"
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
        expected = "http://gatoarcano.cl/product-category/juegos-de-mesa/page/2/"
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
