#!/usr/bin/env ruby
# frozen_string_literal: true

require "csv"
require "logger"
require_relative "../lib/hashed_storage"
require_relative "../lib/image_fetcher"
require_relative "../lib/image_downloader"

MY_LOGGER = Logger.new($stdout, level: :info)

OUTPUT_DIR = "images/original"
MY_STORAGE = HashedStorage.new(OUTPUT_DIR)

all_urls = Dir.glob("db/*.csv")
              .map { |csv| CSV.table(csv, converters: nil) }
              .flat_map { |table| table[:image_url] }
              .compact
              .uniq

filtered_urls = all_urls.filter_map do |url|
  URI.parse(url)
rescue URI::InvalidURIError, NoMethodError => e
  MY_LOGGER.error { "Invalid URL: #{url} error: #{e.full_message} skipping" }
  nil
end

grouped = filtered_urls.group_by(&:host)

threads = grouped.each_with_index.map do |(host, urls), index|
  progname = format("Thread (%02d)", index)
  Thread.new do
    MY_LOGGER.info(progname) { "Started thread for origin: #{host}" }
    downloader = ImageDownloader.new(
      urls: urls,
      storage: MY_STORAGE,
      logger: MY_LOGGER,
      progname: progname
    )
    downloader.run
    MY_LOGGER.info(progname) { "Finished thread for origin: #{host}" }
  end
end

threads.each(&:join)
