# frozen_string_literal: true

require "tanakai_helper"

RSpec.describe Validator do
  let(:validator) do
    instance = described_class.new
    instance.spider = Tanakai::Base.new
    instance
  end

  let(:item) do
    {
      url: "https://www.example.com/item/1",
      title: "Example Item",
      price: 123_456,
      stock: true
    }
  end

  describe "item.url" do
    it "does allow different urls" do
      expect do
        validator.process_item(item)
        item[:url] = "https://www.example.com/item/2"
        validator.process_item(item)
      end.not_to raise_error
    end

    it "does not allow duplicated urls" do
      validator.process_item(item)

      expect do
        validator.process_item(item)
      end.to raise_error(Tanakai::Pipeline::DropItemError)
    end

    it "does not allow relative urls" do
      item[:url] = "/item/1"
      expect do
        validator.process_item(item)
      end.to raise_error(Tanakai::Pipeline::DropItemError)
    end
  end

  describe "stock" do
    it "does allow in-stock items" do
      expect do
        validator.process_item(item)
      end.not_to raise_error
    end

    it "does not allow out-of-stock items" do
      item[:stock] = false

      expect do
        validator.process_item(item)
      end.to raise_error(Tanakai::Pipeline::DropItemError)
    end
  end

  describe "item.price" do
    it "does not allow nil prices" do
      item[:price] = nil
      expect do
        validator.process_item(item)
      end.to raise_error(Tanakai::Pipeline::DropItemError)
    end

    it "does not allow 0 prices" do
      item[:price] = 0
      expect do
        validator.process_item(item)
      end.to raise_error(Tanakai::Pipeline::DropItemError)
    end

    it "does not allow negative prices" do
      item[:price] = -1
      expect do
        validator.process_item(item)
      end.to raise_error(Tanakai::Pipeline::DropItemError)
    end

    it "does not allow float prices" do
      item[:price] = 1.1
      expect do
        validator.process_item(item)
      end.to raise_error(Tanakai::Pipeline::DropItemError)
    end

    ["$12.990", "12.990", "12990", "$ 12.990,00"].each do |price|
      it "does not allow string prices like: #{price}" do
        expect do
          item[:price] = price
          validator.process_item(item)
        end.to raise_error(Tanakai::Pipeline::DropItemError)
      end
    end
  end
end
