# Hooks onto Episode and maintains the total_length sum on the Media
class MediaTotalLengthCallbacks < Callbacks
  # @param klass [Class] the class to hook the callbacks for
  def self.hook(klass)
    klass.after_create(self)
    klass.after_destroy(self)
    klass.after_update(self)
  end

  def after_create
    media.with_lock do
      media.total_length ||= 0
      media.total_length += record.length if record.length
      media.save!
    end
  end

  def after_destroy
    media.with_lock do
      media.total_length ||= 0
      media.total_length -= record.length if record.length
      media.save!
    end
  end

  def after_update
    media.with_lock do
      media.total_length ||= 0
      media.total_length += ((record.length || 0) - (record.length_was || 0))
      media.save!
    end
  end

  delegate :media, to: :record
end
