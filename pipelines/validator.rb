# frozen_string_literal: true

class Validator < Tanakai::Pipeline
  def process_item(item, options: {})
    # No duplicates
    raise DropItemError, "Item url is not unique" unless unique?(:url, item[:url])

    # No out-of-stock items
    raise DropItemError, "Item out of stock" unless item[:stock]

    # Has title present
    raise DropItemError, "Invalid title" unless item[:title].present?

    # Catch zero prices
    raise DropItemError, "Invalid price" if item[:price].zero?

    # Catch relative urls
    raise DropItemError, "Invalid url" if URI.parse(item[:url]).host.nil?

    # Pass item to the next pipeline (if it wasn't dropped)
    item
  end
end
