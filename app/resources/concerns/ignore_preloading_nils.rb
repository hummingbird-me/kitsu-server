# frozen_string_literal: true

# jsonapi-resources 0.10 removed the preloaded fragment pipeline this patched.
module IgnorePreloadingNils
  extend ActiveSupport::Concern
end
