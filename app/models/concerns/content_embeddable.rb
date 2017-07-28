module ContentEmbeddable
  extend ActiveSupport::Concern

  class_methods do
    def embed_links_in(content_attr, to:)
      url_var = :"@#{to}_url"
      processed_attr = :"processed_#{content_attr}"

      define_method("#{to}=") do |value|
        if value.is_a?(String)
          instance_variable_set(url_var, value)
        else
          super(value)
        end
      end

      validate do
        processed = send(processed_attr)
        embed_url = instance_variable_get(url_var)
        if embed_url && !processed[:embeddable_links].include?(embed_url)
          errors.add(to, 'must exist in content')
        end
      end

      before_validation do
        processed = send(processed_attr)
        embed_url = instance_variable_get(url_var)
        self.embed = embed_url ? EmbedService.new(embed_url).as_json : processed[:embed]
      end
    end
  end
end
