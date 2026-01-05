# frozen_string_literal: true

require "spider_helper"

RSpec.describe JugandoAndoSpider, :spider, engine: :custom do
  let(:fixture_directory) { "jugando_ando" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 20 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(20)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://jugandoando.cl/producto/set-arco-mini-arco",
          title: "Set ARCO – Mini ARCO",
          price: 549_990,
          stock: true,
          image_url: "https://emidica-space.nyc3.cdn.digitaloceanspaces.com/img/shops/28092/products/2551242/f2ce65d7-7e05-4d74-b052-6e6ef9722d8e.webp"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://jugandoando.cl/producto/el-monstruo-de-colores-juego-para-conectar-con-las-emociones-de-tus-hijos",
          title: "El Monstruo de Colores – Juego para conectar con las emociones de tus hijos",
          price: 28_990,
          stock: true,
          image_url: "https://emidica-space.nyc3.cdn.digitaloceanspaces.com/img/shops/28092/products/2417238/603171b4-94ed-4842-b8f8-f2fbae25c6fc.webp"
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
        expected = "https://jugandoando.cl/categoria/todos-los-juegos-28092?page=2"
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
