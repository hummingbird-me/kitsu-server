# frozen_string_literal: true

class ImageInfo
  def initialize(file_path)
    @file_path = file_path
  end

  def type
    if fastimage.type == :png && animated?
      :apng
    else
      fastimage.type
    end
  end

  def animated?
    FastImage.animated?(@file_path)
  end

  private

  def fastimage
    @fastimage ||= FastImage.new(@file_path)
  end
end
