# frozen_string_literal: true

require "spider_helper"

RSpec.describe UpdownSpider, :spider, engine: :woocommerce do
  let(:fixture_directory) { "updown" }
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
          url: "https://www.updown.cl/producto/dice-throne-marvel-caja-1-bruja-escarlata-thor-loki-y-spider-man/",
          title: "Dice Throne Marvel Caja 1 (Bruja Escarlata, Thor, Loki y Spider-Man) + Correcciones",
          price: 72_990,
          stock: true,
          image_url: "https://www.updown.cl/wp-content/uploads/2025/11/standard_resolution-167.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.updown.cl/producto/dominant-species/",
          title: "Dominant Species",
          price: 99_990,
          stock: true,
          image_url: "https://www.updown.cl/wp-content/uploads/2025/11/standard_resolution-22.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end


    context "with an out-of-stock product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.updown.cl/producto/dominion/",
          title: "Dominion",
          price: 36_990,
          stock: false,
          image_url: "https://www.updown.cl/wp-content/uploads/2025/09/standard_resolution-726.jpg"
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
        expected = "https://www.updown.cl/categoria-producto/juegos-de-mesa/page/2/"
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
