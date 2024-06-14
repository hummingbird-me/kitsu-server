# frozen_string_literal: true

RSpec.configure do |config|
  config.include GraphQL::Testing::Helpers.for(KitsuSchema)
end
