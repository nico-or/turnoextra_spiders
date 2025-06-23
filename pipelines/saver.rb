# frozen_string_literal: true

# Saves an item to disk
class Saver < Tanakai::Pipeline
  def process_item(item, options: {})
    # Here you can save item to the database, send it to a remote API or
    # simply save item to a file format using `save_to` helper:

    # To get the name of a current spider: `spider.class.name`
    # save_to "db/#{spider.class.name}.json", item, format: :pretty_json

    # Add today's date
    item[:date] = Date.today

    save_to "db/#{datestamp}_#{spider.class.name}.csv", item, format: :csv

    item
  end

  private

  def datestamp
    Time.now.strftime("%Y%m%d")
  end
end
