require 'factory_bot'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Group hardcodes category 9 as the NSFW one, so keep factory-made categories off that ID
  config.before(:suite) do
    ActiveRecord::Base.connection.execute(<<~SQL.squish)
      SELECT setval('group_categories_id_seq', GREATEST(nextval('group_categories_id_seq'), 9))
    SQL
  end
end
