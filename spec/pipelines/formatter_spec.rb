# frozen_string_literal: true

require "pipeline_helper"

RSpec.describe Formatter do
  subject(:formatted_item) { pipeline.process_item(item) }

  let(:pipeline) do
    instance = described_class.new
    instance.spider = Tanakai::Base.new
    instance
  end

  let(:item) do
    {
      url: url,
      title: title,
      price: 123_456,
      stock: true,
      image_url: image_url
    }
  end

  let(:title) { "Example Item" }
  let(:url) { "https://www.example.com/item/1" }
  let(:image_url) { "https://www.example.com/item/1.jpg" }

  describe "#format_title" do
    context "when title has extra whitespace" do
      let(:title) { " Example Item \n" }

      it "strips whitespace from the title" do
        expect(formatted_item[:title]).to eq("Example Item")
      end
    end
  end

  describe "#format_url" do
    it_behaves_like "a URL sanitizer", :url
  end

  describe "#format_image_url" do
    it_behaves_like "a URL sanitizer", :image_url
  end
end
