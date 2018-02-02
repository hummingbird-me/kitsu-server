class EmbedLinkCallbacks < Callbacks
  # @param klass [Class] the class to hook the callbacks for
  def self.hook(klass)
    klass.after_validation(self)
  end

  # Update the embed if the URL is present or if the content changed
  def after_validation
    record.public_send("#{to}=", embed) if embed_url.present? || content_changed?
  end

  # Try to fill in the embed if there's not already one
  def after_find
    record.update(to => embed) if record.public_send(to).blank?
  end

  private

  def embed
    EmbedService.new(embed_url).as_json if embed_url
  rescue StandardError => e
    Raven.capture_exception(e)
    nil
  end

  def embed_url
    record.public_send("#{to}_url") || processed[:embeddable_links]&.first
  end

  def processed
    record.public_send("processed_#{content_attr}")
  end

  def content_changed?
    record.public_send("#{content_attr}_changed?")
  end

  def to
    options[:to]
  end

  def content_attr
    options[:content_attr]
  end
end
