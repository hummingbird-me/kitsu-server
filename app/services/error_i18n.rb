class ErrorI18n
  def self.t(error)
    key = error.class.underscore.tr('/', '.')
    message = I18n.t(key, scope: 'errors', default: 'Unknown Error')
  end
end
