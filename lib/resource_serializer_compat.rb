# frozen_string_literal: true

module JSONAPI
  class ResourceSerializer
    def serialize_to_hash(source)
      is_collection = source.respond_to?(:to_ary)
      resources = Array.wrap(source).compact.select(&:id)

      return { 'data' => is_collection ? [] : nil } if resources.empty?

      context = resources.first.context
      resource_id_tree = primary_resource_id_tree_for(resources)
      load_included_resources(resource_id_tree, context)

      resource_set = ResourceSet.new(resource_id_tree)
      resources.each { |resource| resource_set.register_resource(resource.class, resource, true) }
      populate_missing_resources(resource_set, context)
      resource_set.mark_populated!

      if is_collection
        serialize_resource_set_to_hash_plural(resource_set)
      else
        serialize_resource_set_to_hash_single(resource_set)
      end
    end

    private

    def primary_resource_id_tree_for(resources)
      tree = PrimaryResourceIdTree.new
      include_related = include_directives.include_directives[:include_related]

      resources.each do |resource|
        fragment = ResourceFragment.new(resource.identity)
        fragment.cache = resource._model.public_send(resource.class._cache_field) if resource.class.caching?
        tree.add_resource_fragment(fragment, include_related)
      end

      tree
    end

    def load_included_resources(resource_id_tree, context)
      include_related = include_directives.include_directives[:include_related]
      return if include_related.blank?

      processor = Processor.new(@primary_resource_klass, :find, { context: })
      processor.send(
        :load_included,
        @primary_resource_klass,
        resource_id_tree,
        include_related,
        context:,
        fields: fields,
        include_directives: include_directives
      )
    end

    def populate_missing_resources(resource_set, context)
      resource_set.resource_klasses.each_pair do |resource_klass, resources_by_id|
        missing_ids = resources_by_id.filter_map do |id, resource_data|
          id unless resource_data[:resource]
        end
        next if missing_ids.empty?

        resource_klass.find_to_populate_by_keys(
          missing_ids,
          context:,
          fields: fields
        ).each do |resource|
          resource_set.register_resource(resource_klass, resource)
        end
      end
    end
  end
end
