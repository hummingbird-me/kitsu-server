module ContentEmbeddable
  extend ActiveSupport::Concern

  class_methods do
    def embed_links_in(content_attr, to:)
      url_attr = :"#{to}_url"
      processed_attr = :"processed_#{content_attr}"

      attr_accessor url_attr

      validate do
        processed = send(processed_attr)
        embed_url = send(url_attr)
        if embed_url && !processed[:embeddable_links].include?(embed_url)
          errors.add(to, 'must exist in content')
        end
      end

      before_validation do
        processed = send(processed_attr)
        embed_url = send(url_attr)
        self.embed = embed_url ? EmbedService.new(embed_url).as_json : processed[:embed]
      end
    end
  end
end
