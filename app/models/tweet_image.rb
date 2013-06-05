class TweetImage < ActiveRecord::Base
  def filename
    File.basename(URI.parse(url).path)
  end
  def basename
    File.basename(filename, '.*')
  end
  def extension
    ext = File.extname(filename)
    if ext.length > 0
      ext = ext[1..-1]
    end
  end
end
