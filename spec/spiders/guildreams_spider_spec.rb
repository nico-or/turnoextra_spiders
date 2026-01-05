# frozen_string_literal: true

require "spider_helper"

RSpec.describe GuildreamsSpider, :spider, engine: :bsale do
  let(:fixture_directory) { "guildreams" }
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
          url: "https://www.guildreams.com/product/the-white-castle-caja-basica",
          title: "The White Castle: Caja Basica",
          price: 31_990,
          stock: true,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/18085/product/M_8436607940593-1200-face3d-copy2267.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_discounted.html") }

      let(:expected) do
        {
          url: "https://www.guildreams.com/product/digimon-card-game-release-special-ver-2-0-booster-box",
          title: "Digimon Card Game: Release Special Ver. 2.0 - Booster Box",
          price: 89_990,
          stock: true,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/18085/product/M_a46b7586a398a272abb3152ac6e2b3e32911.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out-of-stock index product node" do
      let(:filename) { File.join("spec/fixtures/stores", fixture_directory, "product_index_node_out_of_stock.html") }

      let(:expected) do
        {
          url: "https://www.guildreams.com/product/the-mind",
          title: "The Mind",
          price: 11_990,
          stock: false,
          image_url: "https://dojiw2m9tvv09.cloudfront.net/18085/product/M_15695483253033161.png"
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
        expected = "https://www.guildreams.com/collection/juegos-de-mesa?order=id&way=DESC&limit=24&page=2"
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
