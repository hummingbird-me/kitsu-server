module BlurhashUploader
  extend ActiveSupport::Concern

  included do
    plugin :blurhash, components: ->(width, height) {
      ratio = width.to_f / height
      # Achieves the following
      # - "component area" <= 15
      # - maintains aspect ratio
      # - clamps in the 2..5 range where it looks nicest
      # Possible outputs are [2, 5], [3, 5], [3, 4], [3, 3], [4, 3], [5, 3], [5, 2]
      x_comp = Math.sqrt(15.to_f / ratio).floor.clamp(2, 5)
      y_comp = (x_comp * ratio).floor.clamp(2, 5)
      [x_comp, y_comp]
    }, on_error: ->(error) { Raven.capture_exception(error) }
  end
end
