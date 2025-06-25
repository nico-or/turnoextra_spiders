# frozen_string_literal: true

# require project gems
require "bundler/setup"
Bundler.require(:default, Tanakai.env)

# require custom ENV variables located in .env file
require "dotenv/load"

# require initializers
Dir.glob(File.join("./config/initializers", "*.rb"), &method(:require))

# require helpers
Dir.glob(File.join("./helpers", "*.rb"), &method(:require))

# require pipelines
Dir.glob(File.join("./pipelines", "*.rb"), &method(:require))

# require spiders recursively in the `spiders/` folder
require_relative "../spiders/application_spider"
Dir.glob(File.join("./spiders", "*.rb"), &method(:require))

# require Tanakai configuration
require_relative "application"
