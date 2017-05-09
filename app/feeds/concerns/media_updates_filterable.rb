module MediaUpdatesFilterable
  extend ActiveSupport::Concern

  included do
    filter :posts, verb: Feed::POST_VERBS
    filter :media, verb: Feed::MEDIA_VERBS
  end
end
