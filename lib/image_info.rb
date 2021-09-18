class ImageInfo
  def initialize(file_path)
    @file_path = file_path
  end

  def type
    if fastimage.type == :png && animated?
      :apng
    else fastimage.type
    end
  end

  def animated?
    frames = MiniMagick::Tool::Identify.new do |magick|
      magick.format '%N'
      magick << (fastimage.type == :png ? "apng:#{@file_path}" : @file_path)
    end
    frames.to_i > 1
  end

  private

  def fastimage
    @fastimage ||= FastImage.new(@file_path)
  end
end
