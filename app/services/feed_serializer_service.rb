class FeedSerializerService
  class FeedSerializer < JSONAPI::ResourceSerializer
    def links_hash(source)
      if source.is_a? ActivityGroupResource
        {}
      else
        super
      end
    end

    def link_object_to_many(*)
      super.reject { |k, v| k == :links }.to_h
    end

    def link_object_to_one(*)
      super.reject { |k, v| k == :links }.to_h
    end

    def relationships_hash(*)
      super.select { |k, v| v.present? }.to_h
    end
  end

  include Skylight::Helpers

  attr_reader :activity_list, :including, :fields, :context, :base_url

  def initialize(list, including: nil, fields: nil, context: nil, base_url:)
    @activity_list = list
    @including = including || []
    @fields = fields || {}
    @context = context || {}
    @base_url = base_url
  end

  instrument_method
  def as_json(*)
    serializer.serialize_to_hash(resources).merge(meta: meta, links: links)
  end

  instrument_method
  def resources
    activities.map { |activity| resource_class.new(activity, context) }
  end

  instrument_method
  def activities
    @activities ||= activity_list.includes(stream_enrichment_fields).to_a
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
    if activities.empty?
      {}
    else
      { next: url_for_params('page[cursor]' => activities.last.id) }
    end
  end

  def stream_enrichment_fields
    @including.map { |inc| inc.split('.').first }
  end

  def serializer
    @serializer ||= ResourceSerializer.new(resource_class, include: including,
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
    query = URI.decode_www_form(uri.query || '').to_h.merge(params)
    uri.query = URI.encode_www_form(query.to_a)
    uri.path = "/api#{uri.path}"
    uri.to_s
  end
end
