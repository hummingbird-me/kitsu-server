class ErrorI18n
  class << self
    def translate(error)
      klass = error.class unless error.is_a?(Class)
      # Filter ancestry to just descendants of StandardError
      ancestors = klass.ancestors.select { |c| c <= StandardError }
      # Convert the class names into I18n keys
      keys = ancestors.map { |c| c.name.underscore.tr('/', '.').to_sym }
      # Look up the main key and fallback to the ancestors
      I18n.t(keys.shift, scope: 'errors', default: keys)
    end
    alias_method :t, :translate
  end
end
