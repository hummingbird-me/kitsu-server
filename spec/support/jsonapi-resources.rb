# frozen_string_literal: true

RSpec.configure do |config|
  # Controller specs don't bother sending a JSON:API Content-Type
  config.before(type: :controller) do
    if controller.respond_to?(:verify_content_type_header)
      allow(controller).to receive(:verify_content_type_header).and_return(true)
    end
  end
end
