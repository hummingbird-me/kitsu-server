class CategoryRecommendationSerializer < JSONAPI::ResourceSerializer
  def self_link(source, relationship)
    return {} if source.class.name == 'CategoryRecommendationResource'
    link_builder.relationships_self_link(source, relationship)
  end

  def related_link(source, relationship)
    return {} if source.class.name == 'CategoryRecommendationResource'
    link_builder.relationships_related_link(source, relationship)
  end

  def object_hash(source, include_directives = {})
    obj_hash = {}

    if source.is_a?(JSONAPI::CachedResourceFragment)
      if source.class.name != 'CategoryRecommendationResource'
        obj_hash['id'] = source.id
      end
      obj_hash['type'] = source.type

      obj_hash['links'] = source.links_json if source.links_json
      obj_hash['attributes'] = source.attributes_json if source.attributes_json

      relationships = cached_relationships_hash(
        source,
        include_directives
      )
      obj_hash['relationships'] = relationships unless relationships.empty?

      obj_hash['meta'] = source.meta_json if source.meta_json
    else
      fetchable_fields = Set.new(source.fetchable_fields)

      if source.class.name != 'CategoryRecommendationResource'
        id_format = source.class._attribute_options(:id)[:format]
        id_format = 'id' if id_format == :default
        obj_hash['id'] = format_value(source.id, id_format)

        links = links_hash(source)
        obj_hash['links'] = links unless links.empty?
      end

      obj_hash['type'] = format_key(source.class._type.to_s)

      attributes = attributes_hash(source, fetchable_fields)
      obj_hash['attributes'] = attributes unless attributes.empty?

      relationships = relationships_hash(
        source,
        fetchable_fields,
        include_directives
      )
      unless relationships.nil? || relationships.empty?
        obj_hash['relationships'] = relationships
      end

      meta = meta_hash(source)
      obj_hash['meta'] = meta unless meta.empty?
    end
    obj_hash
  end
end
