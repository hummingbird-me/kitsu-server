module HasImageField
  extend ActiveSupport::Concern

  class_methods do
    def image_field(key, **options)
      options = {
        type: Types::Image,
        null: true
      }.merge(options)

      field(key, options) do
        yield if block_given?
      end

      define_method(key) do
        attacher = if options[:method] && object.respond_to?(:"#{options[:method]}_attacher")
          object.public_send(:"#{options[:method]}_attacher")
        elsif options[:method]
          object.public_send(options[:method])
        else
          object.public_send(:"#{key}_attacher")
        end

        attacher if attacher.file.present?
      end
    end
  end
end
