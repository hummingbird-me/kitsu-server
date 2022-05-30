class Types::Errors::WarningsPresent < Types::Errors::Base
  description <<~DESCRIPTION.squish
    Returned when a warning is present in the response from a mutation but the input did not specify
    ignore_warnings: true
  DESCRIPTION

  def message
    I18n.t('graphql.errors.warnings_present')
  end
end
