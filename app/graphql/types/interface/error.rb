# frozen_string_literal: true

module Types::Interface::Error
  include Types::Interface::Base

  description 'Generic error fields used by all errors.'
  orphan_types Types::Errors::Generic

  field :message, String,
    null: false,
    description: 'A description of the error'

  def message
    message_key = self.class.name.split('::')[2..].join('.').underscore

    I18n.t("graphql.errors.#{message_key}")
  end

  field :path, [String],
    null: true,
    description: 'Which input value this error came from'

  field :code, String,
    null: true,
    description: 'The error code.'
end
