# frozen_string_literal: true

class HashedStorage
  attr_reader :root, :level_width, :levels

  def initialize(root, level_width: 2, levels: 2)
    @root = root
    @level_width = level_width
    @levels = levels

    create_directory(root)
  end

  def save(filename, data)
    digest = digest_for(filename)
    filepath = digested_path_for(digest)
    return filepath if File.exist?(filepath)

    create_directory(filepath)
    File.binwrite(filepath, data)
    filepath
  end

  def read(filename)
    digest = digest_for(filename)
    filepath = digested_path_for(digest)
    return unless File.exist?(filepath)

    File.read(filepath)
  end

  def exist?(filename)
    digest = digest_for(filename)
    File.exist?(digested_path_for(digest))
  end

  def delete(filename)
    digest = digest_for(filename)
    path = digested_path_for(digest)
    FileUtils.rm_f(path)
  end

  private

  def create_directory(filepath)
    path = File.dirname(filepath)
    FileUtils.mkdir_p(path)
  end

  def digest_for(string)
    Digest::MD5.hexdigest(string)
  end

  def digested_filename_for(filename)
    digest_for(filename) + File.extname(filename)
  end

  def digested_path_for(filename)
    digest = digested_filename_for(filename)
    path = root
    idx = 0
    levels.times do
      path = File.join(path, digest[idx, level_width])
      idx += level_width
    end
    File.join(path, digest[idx..])
  end
end
