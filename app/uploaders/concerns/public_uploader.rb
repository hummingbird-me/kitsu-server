module PublicUploader
  extend ActiveSupport::Concern

  included do
    plugin :url_options, Shrine.opts[:url_options].deep_merge(store: { public: true })
  end
end
