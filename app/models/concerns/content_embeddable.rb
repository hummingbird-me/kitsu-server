module ContentEmbeddable
  extend ActiveSupport::Concern

  class_methods do
    def embed_links_in(content_attr, to:)
      url_attr = :"#{to}_url"
      processed_attr = :"processed_#{content_attr}"

      attr_accessor url_attr

      before_validation if: -> {
        send(url_attr) || send("#{content_attr}_changed?")
      } do
        processed = send(processed_attr)
        embed_url = send(url_attr) || processed[:embeddable_links].first
        begin
          self.embed = EmbedService.new(embed_url).as_json
        rescue e
          Raven.capture_exception(e)
        end
      end

      after_find unless: :embed? do
        processed = send(processed_attr)
        embed_url = send(url_attr) || processed[:embeddable_links].first
        begin
          update(embed: EmbedService.new(embed_url).as_json)
        rescue e
          Raven.capture_exception(e)
        end
      end
    end
  end
end
