# frozen_string_literal: true

# Rails 7.2 dropped the positional `bold` argument of LogSubscriber#color, which chewy 0.9 (pinned
# by our Elasticsearch 2 cluster), flipper 0.28 and graphql-client 0.22 still pass.
ActiveSupport::LogSubscriber.prepend(Module.new do
  private

  def color(text, color, mode_options = {})
    mode_options = { bold: mode_options } if [true, false].include?(mode_options)
    super
  end
end)
