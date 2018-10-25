module HasLocalizedField
  extend ActiveSupport::Concern

  class_methods do
    def localized_field(key, **options)
      options = {
        type: Types::Map,
        null: false
      }.merge(options)

      field(key, options) do
        argument :locales, [String], required: false

        yield if block_given?
      end

      define_method(key) do |**params|
        locales = params[:locales]
        # TODO: fall back to Accept-Language header by default?
        titles = if object.respond_to?(key)
                   object.public_send(key)
                 elsif object.respond_to?(:key?) && object.key?(key)
                   object[key]
                 else super
                 end
        titles = titles.slice(*locales) if locales
        titles
      end
    end
  end
end
