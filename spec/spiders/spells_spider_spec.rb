# frozen_string_literal: true

require "spider_helper"

RSpec.describe SpellsSpider, :spider, engine: :woocommerce do
  let(:fixture_directory) { "spells" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures/stores", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 30 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(30)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://spells.cl/producto/gg-protector-standard-prime-plomo-66x91-50-unidades/",
          title: "GG PROTECTOR – STANDARD PRIME (PLOMO) – 66X91 (50 UNIDADES)",
          price: 4_000,
          stock: true,
          image_url: "https://spells.cl/wp-content/uploads/2023/09/GG-PROTECTOR-STANDARD-PRIME-PLOMO-59X91-50-UNIDADES.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://spells.cl/producto/dnd-el-trueno-del-rey-de-la-tormenta/",
          title: "DnD EL TRUENO DEL REY DE LA TORMENTA",
          price: 25_000,
          stock: true,
          image_url: "https://spells.cl/wp-content/uploads/2023/09/DD-EL-TRUENO-DEL-REY-DE-LA-TORMENTA.png"
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
        expected = "https://spells.cl/categoria-producto/juegos-de-mesa/page/2/"
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
