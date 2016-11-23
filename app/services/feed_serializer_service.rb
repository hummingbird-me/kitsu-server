class FeedSerializerService
  attr_reader :activity_list, :including, :fields, :context, :id_lt, :base_url

  def initialize(activity_list, including: nil, fields: nil, context: nil,
                 base_url:)
    @activity_list = activity_list
    @including = including || []
    @fields = fields || []
    @context = context || {}
    @base_url = base_url
  end

  def as_json(*)
    serializer.serialize_to_hash(resources).merge(meta: meta, links: links)
  end

  def resources
    activities.map { |activity| resource_class.new(activity, context) }
  end

  def activities
    activity_list.includes(stream_enrichment_fields).to_a
  end

  def including
    if feed.aggregated? || feed.notification?
      @including.map { |inc| "activities.#{inc}" } + ['activities']
    else
      @including
    end
  end

  def meta
    { readonlyToken: activity_list.feed.readonly_token }
  end

  def links
    { next: url_for_params('page[cursor]' => activities.last.id) }
  end

  def stream_enrichment_fields
    @including.map { |inc| inc.split('.').first }
  end

  def serializer
    JSONAPI::ResourceSerializer.new(resource_class, include: including,
                                    fields: fields)
  end

  def resource_class
    if feed.aggregated? || feed.notification?
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
    query = URI.decode_www_form(uri.query || '') + params.to_a
    uri.query = URI.encode_www_form(query)
    uri.path = "/api#{uri.path}"
    uri.to_s
  end
end
