module ContentEmbeddable
  extend ActiveSupport::Concern

  class_methods do
    def embed_links_in(content_attr, to:)
      attr_accessor :"#{to}_url"
      EmbedLinkCallbacks.with_options(content_attr: content_attr, to: to).hook(self)
    end
  end
end
