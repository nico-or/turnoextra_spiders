# frozen_string_literal: true

require "tanakai_helper"

RSpec.describe Formatter do
  let(:pipeline) do
    instance = described_class.new
    instance.spider = Tanakai::Base.new
    instance
  end

  let(:item) do
    {
      url: "https://www.example.com/item/1",
      title: "Example Item",
      price: 123_456,
      stock: true,
      image_url: "https://www.example.com/item/1.jpg"
    }
  end

  it "formats the item title" do
    item[:title] = " Example Item \n"
    formated_item = pipeline.process_item(item)
    expect(formated_item[:title]).to eq("Example Item")
  end

  it "removes url query parameters" do
    item[:url] = "https://lateka.cl/products/7-wonders-edifice-expansion?_pos=232&_fid=c752bb366&_ss=c"
    formated_item = pipeline.process_item(item)
    expect(formated_item[:url]).to eq("https://lateka.cl/products/7-wonders-edifice-expansion")
  end

  it "removes url fragment" do
    item[:url] = "https://lateka.cl/products/7-wonders-edifice-expansion#example"
    formated_item = pipeline.process_item(item)
    expect(formated_item[:url]).to eq("https://lateka.cl/products/7-wonders-edifice-expansion")
  end

  it "removes url query parameters and fragments" do
    item[:url] = "https://lateka.cl/products/7-wonders-edifice-expansion?_pos=232&_fid=c752bb366&_ss=c#example"
    formated_item = pipeline.process_item(item)
    expect(formated_item[:url]).to eq("https://lateka.cl/products/7-wonders-edifice-expansion")
  end
end
