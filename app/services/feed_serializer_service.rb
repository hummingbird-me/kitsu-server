class FeedSerializerService
  class FeedSerializer < JSONAPI::ResourceSerializer
    def links_hash(source)
      if source.is_a? ActivityGroupResource
        {}
      else
        super
      end
    end

    def foreign_key_value(source, relationship)
      related_resource_id = if source.preloaded_fragments.has_key?(format_key(relationship.name))
        source.preloaded_fragments[format_key(relationship.name)].values.first.try(:id)
      elsif source._model.respond_to?("#{relationship.name}_id")
        # If you have direct access to the underlying id, you don't have to load the relationship
        # which can save quite a lot of time when loading a lot of data.
        # This does not apply to e.g. has_one :through relationships.
        source._model.public_send("#{relationship.name}_id")
      else
        source.public_send(relationship.name).try(:id)
      end
      return nil unless related_resource_id
      @id_formatter.format(related_resource_id)
    end

    def link_object_to_many(*)
      super.reject { |k, _v| k == :links }.to_h
    end

    def link_object_to_one(*)
      super.reject { |k, _v| k == :links }.to_h
    end

    def relationships_hash(*)
      super.select { |_k, v| v.present? }.to_h
    end
  end

  attr_reader :activity_list, :including, :fields, :context, :stream_feed,
    :base_url

  def initialize(list, including: nil, fields: nil, context: nil, stream_feed:,
    base_url:)
    @including = including || []
    @fields = fields || {}
    @context = context || {}
    @base_url = base_url
    @stream_feed = stream_feed
    @activity_list = list.includes(stream_enrichment_fields)
  end

  def as_json(*)
    serializer.serialize_to_hash(resources).merge(meta: meta, links: links)
  end

  def resources
    activities.map { |activity| resource_class.new(activity, context) }
  end

  def activities
    @activities ||= activity_list.to_a
  end

  def including
    if feed.aggregated?
      @including.map { |inc| "activities.#{inc}" } + ['activities']
    else
      @including
    end
  end

  def meta
    {
      feed: {
        group: stream_feed.group,
        id: stream_feed.id,
        token: stream_feed.readonly_token
      },
      readonlyToken: activity_list.feed.readonly_token,
      unseenCount: activity_list.unseen_count,
      unreadCount: activity_list.unread_count
    }.compact
  end

  def links
    if activity_list.more? && activities.count != 0
      { next: url_for_params('page[cursor]' => activities.last.id) }
    else
      {}
    end
  end

  def stream_enrichment_fields
    @including.each_with_object([]) do |inc, includes|
      field, reference = inc.split('.')

      if (field == 'subject' || field == 'target') && !reference.nil?
        includes.push(*non_polymorphic_references(reference))
      else
        includes << field
      end
    end
  end

  def serializer
    @serializer ||= FeedSerializer.new(resource_class, include: including,
                                                       fields: fields)
  end

  def resource_class
    if feed.aggregated?
      ActivityGroupResource
    else
      ActivityResource
    end
  end

  def feed
    activity_list.feed
  end

  private

  def url_for_params(params)
    uri = URI.parse(base_url)
    query = URI.decode_www_form(uri.query || '').to_h.merge(params)
    uri.query = URI.encode_www_form(query.to_a)
    uri.to_s
  end

  def non_polymorphic_references(reference, models: nil)
    models ||= [Post, Comment, LibraryEntry]

    models.each_with_object([]) do |model, references|
      if model.reflections.keys.include?(reference)
        references << "#{model.name.underscore}.#{reference}"
      end
    end
  end
end
