# frozen_string_literal: true

require "spider_helper"

RSpec.describe SomosJuegosSpider do
  let(:fixture_directory) { "somos_juegos" }
  let(:spider) { described_class.new }
  let(:store_url) { described_class.store[:url] }

  it_behaves_like "a store spider"

  describe "#parse_index" do
    let(:response) do
      html = File.read(File.join("spec/fixtures", fixture_directory, "index_page_paginate_true.html"))
      Nokogiri::HTML(html)
    end

    it "returns 50 items" do
      items = spider.send(:parse_index, response, url: store_url)
      expect(items.length).to eq(50)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_regular.html") }

      let(:expected) do
        {
          url: "https://www.somosjuegos.cl/collections/juegos-de-mesa/products/juegos-de-mesa-amigos-de-mierda-buro",
          title: "Amigos de mierda",
          price: 12_990,
          stock: true,
          image_url: "https://www.somosjuegos.cl/cdn/shop/files/amigos-de-mierda-7f8e5161-6015-460e-a9c0-2db66a39dc0c.png"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.somosjuegos.cl/collections/juegos-de-mesa/products/refumanyi",
          title: "Refumanyi",
          price: 6_495,
          stock: true,
          image_url: "https://www.somosjuegos.cl/cdn/shop/files/refu-6d947311-2e3a-4d7d-81d4-c60db5b57ff2_8979c721-8688-4c7c-880c-f5c08e05e946.webp"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an no_image index product node" do
      let(:filename) { File.join("spec/fixtures", fixture_directory, "product_index_node_no_image.html") }

      let(:expected) do
        {
          url: "https://www.somosjuegos.cl/collections/juegos-de-mesa/products/pack-juicio-final-con-aji",
          title: "Pack Juicio Final Con Aji",
          price: 27_986,
          stock: true,
          image_url: nil
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
        expected = "https://www.somosjuegos.cl/collections/juegos-de-mesa?page=2"
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
