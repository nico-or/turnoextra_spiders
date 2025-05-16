# frozen_string_literal: true

require "mechanize"

# Class to handle HTTP requests for images.
class ImageFetcher
  def initialize(logger:)
    @logger = logger
    @agent = Mechanize.new
    @agent.user_agent = user_agent
  end

  def fetch(url, progname:)
    @agent.get(url)
  rescue Mechanize::ResponseCodeError => e
    @logger.warn(progname) { "Failed to fetch #{url}: #{e.full_message}" }
  rescue StandardError => e
    @logger.error(progname) { "Failed to fetch #{url}: #{e.full_message}" }
  end

  private

  def user_agent
    "TurnoExtraBot/1.0 (+https://turnoextra.cl/contact) Ruby/#{RUBY_VERSION} Mechanize/#{Mechanize::VERSION}"
  end
end
