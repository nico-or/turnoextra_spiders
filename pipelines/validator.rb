# frozen_string_literal: true

class Validator < Tanakai::Pipeline
  def process_item(item, options: {})
    # No duplicates
    raise DropItemError, "Item url is not unique" unless unique?(:url, item[:url])

    # Pass item to the next pipeline (if it wasn't dropped)
    item
  end
end
