class FeedSerializerService
  attr_reader :activity_list, :including, :fields

  def initialize(activity_list, including: nil, fields: nil)
    @activity_list = activity_list
    @including = including || []
    @fields = fields || []
  end

  def as_json(*)
    serializer.serialize_to_hash(resources)
  end

  def resources
    activity_list.to_a.map { |activity| resource_class.new(activity, nil) }
  end

  def including
    if feed.aggregated? || feed.notification?
      @including.map { |inc| "activities.#{inc}" } + ['activities']
    else
      @including
    end
  end

  def serializer
    JSONAPI::ResourceSerializer.new(resource_class, include: including,
                                    fields: fields)
  end

  def resource_class
    if feed.aggregated? || feed.notification?
      Feed::ActivityGroupResource
    else
      Feed::ActivityResource
    end
  end

  def feed
    activity_list.feed
  end
end
