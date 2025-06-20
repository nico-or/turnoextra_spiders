# frozen_string_literal: true

require "tanakai_helper"

RSpec.describe TitleFormatter do
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
end
