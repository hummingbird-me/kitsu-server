require 'marginalia'

module Marginalia::Comment
  def self.request_path
    @controller.request.fullpath
  end
end

Marginalia::Comment.components = %i[controller_with_namespace action request_path]
