# frozen_string_literal: true

# Make a mistake in the HashedStorage class where the image_url was hashed twice
# This script migrates the data to fix the issue.

require "csv"
require "digest/md5"
require "fileutils"
require "logger"
require "pathname"

LOG_FILE = "log/migrate.log"

FileUtils.rm LOG_FILE

logger = Logger.new(LOG_FILE)
logger.level = Logger::DEBUG

# Helper methods for handling file paths and digests.
def bad_pathname(digest)
  p1 = digest[0..1]
  p2 = digest[2..3]
  p3 = digest[4..]

  File.join(p1, p2, p3)
end

def good_pathname(digest)
  p1 = digest[0..1]
  p2 = digest[2..3]

  File.join(p1, p2, digest)
end

def hash_from_bad_pathname(filename)
  Pathname.new(filename)
          .each_filename
          .to_a
          .last(3)
          .join
          .then { |p| File.basename(p, ".jpg") }
end

# Read URLs from CSV files and group file paths by their MD5 hash.
urls = Dir.glob("db/*.csv")
          .map { |file| CSV.table(file, converters: nil) }
          .map { |table| table[:image_url] }
          .flatten
          .compact
          .uniq

filepaths = Dir.glob("images/**/*").select { |path| File.file? path }

grouped = filepaths.group_by do |path|
  hash_from_bad_pathname(path)
end

# Process each URL and update the file paths accordingly.
urls.each do |url|
  logger.info "Processing URL: #{url}"

  good_digest = Digest::MD5.hexdigest(url)
  bad_digest = Digest::MD5.hexdigest(good_digest)

  logger.debug "Good Digest: #{good_digest}"
  logger.debug "Bad Digest: #{bad_digest}"

  old_filepaths = grouped[bad_digest]

  next if old_filepaths.nil? || old_filepaths.empty?

  old_filepaths.each do |old_filepath|
    old_extension = File.extname(old_filepath)
    old_directory = File.dirname(old_filepath, 3)
    new_filename = good_pathname(good_digest) + old_extension
    new_filepath = File.join(old_directory, new_filename)
    new_directory = File.dirname(new_filepath)

    logger.info "Moving #{old_filepath} to #{new_filepath}"

    FileUtils.mkdir_p(new_directory)
    FileUtils.mv(old_filepath, new_filepath)
  end
end
