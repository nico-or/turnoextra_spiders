# frozen_string_literal: true

require "tanakai_helper"

RSpec.describe Validator do
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
      image_url: "https://www.example.com/images/item-1.png"
    }
  end

  describe "item.url" do
    context "when URLs are unique and absolute" do
      it "doesn't raise DropItemError" do
        expect do
          pipeline.process_item(item)
          item[:url] = "https://www.example.com/item/2"
          pipeline.process_item(item)
        end.not_to raise_error
      end
    end

    context "when URLs are duplicated" do
      it "raises DropItemError" do
        pipeline.process_item(item)
        expect do
          pipeline.process_item(item)
        end.to raise_error(Tanakai::Pipeline::DropItemError)
      end
    end

    context "when URL is relative" do
      it "raises DropItemError" do
        item[:url] = "/item/1"
        expect do
          pipeline.process_item(item)
        end.to raise_error(Tanakai::Pipeline::DropItemError)
      end
    end
  end

  describe "item.stock" do
    context "when stock is true" do
      it "allows the item" do
        expect do
          pipeline.process_item(item)
        end.not_to raise_error
      end
    end

    context "when stock is false" do
      it "raises DropItemError" do
        item[:stock] = false
        expect do
          pipeline.process_item(item)
        end.to raise_error(Tanakai::Pipeline::DropItemError)
      end
    end
  end

  describe "item.price" do
    context "when price is nil" do
      it "raises DropItemError" do
        item[:price] = nil
        expect do
          pipeline.process_item(item)
        end.to raise_error(Tanakai::Pipeline::DropItemError)
      end
    end

    context "when price is 0" do
      it "raises DropItemError" do
        item[:price] = 0
        expect do
          pipeline.process_item(item)
        end.to raise_error(Tanakai::Pipeline::DropItemError)
      end
    end

    context "when price is negative" do
      it "raises DropItemError" do
        item[:price] = -1
        expect do
          pipeline.process_item(item)
        end.to raise_error(Tanakai::Pipeline::DropItemError)
      end
    end

    context "when price is an integer" do
      it "allows the item" do
        item[:price] = 1
        expect do
          pipeline.process_item(item)
        end.not_to raise_error
      end
    end

    context "when price is a float" do
      it "raises DropItemError" do
        item[:price] = 1.1
        expect do
          pipeline.process_item(item)
        end.to raise_error(Tanakai::Pipeline::DropItemError)
      end
    end

    context "when price is a string" do
      ["foo", "$12.990", "12.990", "12990", "$ 12.990,00"].each do |price|
        it "raises DropItemError for a price like: #{price}" do
          item[:price] = price
          expect do
            pipeline.process_item(item)
          end.to raise_error(Tanakai::Pipeline::DropItemError)
        end
      end
    end
  end
end
