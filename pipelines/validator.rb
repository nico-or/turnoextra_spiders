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
    raise DropItemError, "Invalid price" unless valid_price?(item[:price])

    # Catch relative urls
    raise DropItemError, "Invalid url" if relative_url?(item[:url])

    # Pass item to the next pipeline (if it wasn't dropped)
    item
  end

  private

  def valid_price?(price)
    price.is_a?(Integer) && price.positive?
  end

  def relative_url?(url)
    URI.parse(url).host.nil?
  end
end
