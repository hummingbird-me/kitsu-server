module ContentEmbeddable
  extend ActiveSupport::Concern

  class_methods do
    def embed_links_in(content_attr, to:)
      url_attr = :"#{to}_url"
      processed_attr = :"processed_#{content_attr}"

      attr_accessor url_attr

      before_validation if: -> {
        send("#{url_attr}_changed?") || send("#{content_attr}_changed?")
      } do
        processed = send(processed_attr)
        embed_url = send(url_attr) || processed[:embeddable_links].first
        self.embed = EmbedService.new(embed_url).as_json
      end

      after_find unless: :embed? do
        processed = send(processed_attr)
        embed_url = send(url_attr) || processed[:embeddable_links].first
        update(embed: EmbedService.new(embed_url).as_json)
      end
    end
  end
end
