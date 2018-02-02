class EmbedLinkCallbacks < Callbacks
  # @param klass [Class] the class to hook the callbacks for
  def self.hook(klass)
    klass.after_validation(self)
    klass.after_find(self)
  end

  # Update the embed if the URL is present or if the content changed
  def after_validation
    record.public_send("#{options.to}=", embed) if embed_url.present? || content_changed?
  end

  # Try to fill in the embed if there's not already one
  def after_find
    update(options.to => embed) if record.public_send(options.to).blank?
  end

  private

  def embed
    EmbedService.new(embed_url).as_json if embed_url
  rescue StandardError => e
    Raven.capture_exception(e)
  end

  def embed_url
    record.public_send(options.url_attr) || processed[:embeddable_links]&.first
  end

  def processed
    record.public_send("processed_#{options.content_attr}")
  end

  def content_changed?
    record.public_send("#{options.content_attr}_changed?")
  end
end
