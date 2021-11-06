require 'marginalia'

module Marginalia::Comment
  def self.request_path
    marginalia_controller.request.fullpath
  rescue StandardError
    nil
  end
end

Marginalia::Comment.components = %i[controller_with_namespace action request_path]
