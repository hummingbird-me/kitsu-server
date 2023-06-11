# frozen_string_literal: true

class Types::Errors::Base < Types::BaseObject
  implements Types::Interface::Error

  def self.exception(object = {})
    FancyMutation::ErrorWrapper.new(build(**object))
  end

  def self.build(**object)
    { __type: self, **object }
  end

  def self.default_graphql_name
    "#{name.split('::')[-1]}Error"
  end
end
