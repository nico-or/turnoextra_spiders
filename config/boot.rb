# frozen_string_literal: true

# require project gems
require "bundler/setup"
Bundler.require(:default)

# require custom ENV variables located in .env file
require "dotenv/load"

# Setup Zeitwerk loader
loader = Zeitwerk::Loader.new

loader.push_dir(File.expand_path("./config/initializers"))
loader.push_dir(File.expand_path("../helpers", __dir__))
loader.push_dir(File.expand_path("../pipelines", __dir__))
loader.push_dir(File.expand_path("../spiders", __dir__))

loader.setup
loader.eager_load

# require Tanakai configuration
require_relative "application"
