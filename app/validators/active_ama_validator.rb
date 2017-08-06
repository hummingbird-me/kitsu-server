class ActiveAMAValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    ama = if value.respond_to?(:post)
            AMA.for_original_post(value.post).first
          elsif value.is_a?(Post)
            AMA.for_original_post(value).first
          else
            value
          end
    return unless ama
    return if ama.author == options[:user]
    return if ama.open?
    record.errors[attribute] << options[:message]
  end
end
