# frozen_string_literal: true

require "spider_helper"

RSpec.describe EntrejuegosSpider do
  let(:spider) { described_class.new }

  describe "#parse_index" do
    let(:response) do
      html = File.read("spec/fixtures/entrejuegos/index_page_paginate_true.html")
      Nokogiri::HTML(html)
    end

    it "returns 36 items" do
      items = spider.send(:parse_index, response)
      expect(items.length).to eq(36)
    end
  end

  describe "#parse_index_node" do
    context "with a regular index product node" do
      let(:filename) { "spec/fixtures/entrejuegos/product_index_node_regular.html" }

      let(:expected) do
        {
          url: "https://www.entrejuegos.cl/juegos-de-mesa/16788-quarto.html",
          title: "quarto",
          price: 29_990,
          stock: true,
          image_url: "https://www.entrejuegos.cl/11925-large_default/quarto.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a truncated name index product node" do
      let(:filename) { "spec/fixtures/entrejuegos/product_index_node_truncated_name.html" }

      let(:expected) do
        {
          url: "https://www.entrejuegos.cl/juegos-de-mesa/16807-potion-explotion-el-quinto-ingrediente.html",
          title: "potion explotion el quinto ingrediente",
          price: 22_990,
          stock: true,
          image_url: "https://www.entrejuegos.cl/11608-large_default/potion-explotion-el-quinto-ingrediente.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a discounted price index product node" do
      let(:filename) { "spec/fixtures/entrejuegos/product_index_node_discounted.html" }

      let(:expected) do
        {
          url: "https://www.entrejuegos.cl/ofertas/16789-cosmic-encounters-duel.html",
          title: "cosmic encounters duel",
          price: 24_990,
          stock: true,
          image_url: "https://www.entrejuegos.cl/11789-large_default/cosmic-encounters-duel.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with an out of stock index product node" do
      let(:filename) { "spec/fixtures/entrejuegos/product_index_node_out_of_stock.html" }

      let(:expected) do
        {
          url: "https://www.entrejuegos.cl/juegos-de-mesa/16800-marvel-united-x-men-equipo-oro.html",
          title: "marvel united x men equipo oro",
          price: 29_990,
          stock: false,
          image_url: "https://www.entrejuegos.cl/11798-large_default/marvel-united-x-men-equipo-oro.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end

    context "with a disabled index product node" do
      let(:filename) { "spec/fixtures/entrejuegos/product_index_node_disabled.html" }

      let(:expected) do
        {
          url: "https://www.entrejuegos.cl/juegos-de-mesa/16717-everdell-spirecrest.html",
          title: "everdell spirecrest",
          price: nil,
          stock: false,
          image_url: "https://www.entrejuegos.cl/11536-large_default/everdell-spirecrest.jpg"
        }
      end

      it_behaves_like "a product node parser"
    end
  end

  describe "#next_page_url" do
    let(:url) { described_class.instance_variable_get("@store")[:url] }

    context "with an index page that has a next page link" do
      let(:response) do
        html = File.read("spec/fixtures/entrejuegos/index_page_paginate_true.html")
        Nokogiri::HTML(html)
      end

      it "has a next page" do
        actual = spider.next_page_url(response, url)
        expected = "https://www.entrejuegos.cl/1064-juegos-de-mesa?page=2"
        expect(actual).to eq(expected)
      end
    end

    context "with an index page that hasn't a next page link" do
      let(:response) do
        html = File.read("spec/fixtures/entrejuegos/index_page_paginate_false.html")
        Nokogiri::HTML(html)
      end

      it "has no next page" do
        actual = spider.next_page_url(response, url)
        expected = nil
        expect(actual).to eq(expected)
      end
    end
  end
end
