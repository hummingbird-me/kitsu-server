class WordfilterCallbacks < InstancedCallbacks
  # @param klass [Class] the class to hook the callbacks for
  # @param location [Symbol] the wordfilter location name
  # @param content_field [Symbol] the field on this class which stores the content
  def self.hook(klass, location, content_field)
    super(klass, { location: location, content_field: content_field })

    attach_callback(klass, :before_validation)
    attach_callback(klass, :after_save)
  end

  def before_validation
    record.send(:"#{options.content_field}=", wordfilter.censored_text) if wordfilter.censor?
    record.hidden_at = Time.now if wordfilter.hide?
    record.errors.add options.content_field, 'contains an inappropriate word' if wordfilter.reject?
  end

  def after_save
    return unless wordfilter.report?

    Report.create!(
      user: User.system_user,
      naughty: record,
      reason: :other,
      explanation: 'Caught by wordfilter'
    )
  end

  private

  def wordfilter
    @wordfilter ||= WordfilterService.new(
      options.location,
      record.public_send(options.content_field)
    )
  end
end
