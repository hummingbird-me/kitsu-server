# frozen_string_literal: true

# Group category 9 is hard-coded as the NSFW one (see Group.sfw), so a factory-made category that
# happened to get that id would hide its groups from signed-out requests. Start the ids past it.
RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.connection.execute("SELECT setval('group_categories_id_seq', 9)")
  end
end
