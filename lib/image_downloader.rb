# frozen_string_literal: true

# Class to handle downloading images from a list of URLs.
class ImageDownloader
  def initialize(urls:, storage:, logger:, progname:)
    @urls = urls
    @logger = logger
    @storage = storage
    @fetcher = ImageFetcher.new(logger: logger)
  end

  def run
    if required_urls.empty?
      @logger.info(@progname) { "No new images to download" }
      return
    end

    required_urls.each { |url| download_url(url) }
  end

  private

  def required_urls
    @urls.reject { |url| @storage.exist?(url) }
  end

  def download_url(url)
    image = @fetcher.fetch(url, progname: @progname)
    unless image
      # FIXME: Magicsur thread crashes here if image is nil instead of getting to next instruction.
      @logger.warn(@progname) { "Failed to download: #{url}" }
      return
    end

    save_image(image, url)
    sleep(4)
  end

  def save_image(image, url)
    @storage.save(url, image.body)
    @logger.info(@progname) { "Saved image: #{url}" }
  end
end
