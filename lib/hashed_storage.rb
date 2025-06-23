# frozen_string_literal: true

# HashedStorage is a file storage interface that organizes files using a directory
# structure based on the MD5 hash of each file's name.
#
# This approach helps avoid filesystem performance issues when storing many files
# by distributing them across nested directories. The depth and width of the
# directory structure are configurable.
#
# Example:
#   storage = HashedStorage.new("/tmp/storage", level_width: 2, levels: 2)
#   storage.save("example.txt", "Hello, world!")
#   content = storage.read("example.txt") # => "Hello, world!"
#
# Given a filename like "example.txt", its MD5 hash (e.g., "1a79a4d60de6718e8e5b326e338ae533")
# would be used to generate a path like:
#   /tmp/storage/1a/79/1a79a4d60de6718e8e5b326e338ae533
class HashedStorage
  attr_reader :root, :level_width, :levels

  def initialize(root, level_width: 2, levels: 2)
    @root = root
    @level_width = level_width
    @levels = levels

    create_directory(root)
  end

  def save(filename, data)
    filepath = digested_path_for(filename)
    return filepath if File.exist?(filepath)

    create_directory(filepath)
    File.binwrite(filepath, data)
    filepath
  end

  def read(filename)
    filepath = digested_path_for(filename)
    return unless File.exist?(filepath)

    File.read(filepath)
  end

  def exist?(filename)
    File.exist?(digested_path_for(filename))
  end

  def delete(filename)
    path = digested_path_for(filename)
    FileUtils.rm_f(path)
  end

  def create_directory(filepath)
    path = File.dirname(filepath)
    FileUtils.mkdir_p(path)
  end

  def digest_for(string)
    Digest::MD5.hexdigest(string)
  end

  # Makes a path for the given filename using a hashed directory structure.
  # example: a digest of "abcd1234" would result in a path like "ab/cd/abcd1234"
  def digested_path_for(filename)
    digest = digest_for(filename)
    path = root
    idx = 0
    levels.times do
      path = File.join(path, digest[idx, level_width])
      idx += level_width
    end
    File.join(path, digest)
  end
end
