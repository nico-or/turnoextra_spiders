# frozen_string_literal: true

require "spider_helper"

RSpec.describe LaBovedaDelMagoSpider, :spider, engine: :woocommerce do
  let(:fixture_directory) { "la_boveda_del_mago" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 40 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(40)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.labovedadelmago.cl/producto/aventureros-al-tren/",
          title: "¡Aventureros al Tren!",
          price: 45_990,
          stock: true,
          image_url: "https://www.labovedadelmago.cl/wp-content/uploads/2022/12/1553713741926_EDGDW02-1.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.labovedadelmago.cl/producto/1000kms/",
          title: "1000 kms",
          price: 25_990,
          stock: true,
          image_url: "https://www.labovedadelmago.cl/wp-content/uploads/2022/10/Mesa-de-trabajo27107.webp"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.labovedadelmago.cl/producto/a-prueba-de-retos/",
          title: "¡A Prueba de Retos!",
          price: 26_990,
          stock: false,
          image_url: "https://www.labovedadelmago.cl/wp-content/uploads/2025/03/oyPShYeyHMYQ45jDcRvu2vA27JwbnFh7AsWx3mx5.jpg"
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
        expected = "https://www.labovedadelmago.cl/page/2/"
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
