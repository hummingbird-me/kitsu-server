module StubHelper
  def open_file(file_name)
    File.read("#{Rails.root}/spec/support/stub_responses/#{file_name}")
  end
end

RSpec.configure do |config|
  config.include StubHelper
end
