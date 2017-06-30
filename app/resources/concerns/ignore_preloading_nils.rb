module IgnorePreloadingNils
  extend ActiveSupport::Concern

  class_methods do
    # rubocop:disable all
    # This beast is copied from jsonapi-resources and as such is subject to their
    # license (MIT) and not the Kitsu license (Apache-2).
    #
    # Why do we have this?  Look for the comment labelled "HACK"
    # TODO: make this hack work on JR 0.10
    def preload_included_fragments(resources, records, serializer, options)
      return if resources.empty?
      res_ids = resources.keys

      include_directives = options[:include_directives]
      return unless include_directives

      context = options[:context]

      # For each association, including indirect associations, find the target record ids.
      # Even if a target class doesn't have caching enabled, we still have to look up
      # and match the target ids here, because we can't use ActiveRecord#includes.
      #
      # Note that `paths` returns partial paths before complete paths, so e.g. the partial
      # fragments for posts.comments will exist before we start working with posts.comments.author
      target_resources = {}
      include_directives.paths.each do |path|
        # If path is [:posts, :comments, :author], then...
        pluck_attrs = [] # ...will be [posts.id, comments.id, authors.id, authors.updated_at]
        pluck_attrs << self._model_class.arel_table[self._primary_key]

        relation = records
          .except(:limit, :offset, :order)
          .where({_primary_key => res_ids})

        # These are updated as we iterate through the association path; afterwards they will
        # refer to the final resource on the path, i.e. the actual resource to find in the cache.
        # So e.g. if path is [:posts, :comments, :author], then after iteration...
        parent_klass = nil # Comment
        klass = self # Person
        relationship = nil # JSONAPI::Relationship::ToOne for CommentResource.author
        table = nil # people
        assocs_path = [] # [ :posts, :approved_comments, :author ]
        ar_hash = nil # { :posts => { :approved_comments => :author } }

        # For each step on the path, figure out what the actual table name/alias in the join
        # will be, and include the primary key of that table in our list of fields to select
        non_polymorphic = true
        path.each do |elem|
          relationship = klass._relationships[elem]
          if relationship.polymorphic
            # Can't preload through a polymorphic belongs_to association, ResourceSerializer
            # will just have to bypass the cache and load the real Resource.
            non_polymorphic = false
            break
          end
          assocs_path << relationship.relation_name(options).to_sym
          # Converts [:a, :b, :c] to Rails-style { :a => { :b => :c }}
          ar_hash = assocs_path.reverse.reduce{|memo, step| { step => memo } }
          # We can't just look up the table name from the resource class, because Arel could
          # have used a table alias if the relation includes a self-reference.
          join_source = relation.joins(ar_hash).arel.source.right.reverse.find do |arel_node|
            arel_node.is_a?(Arel::Nodes::InnerJoin)
          end
          table = join_source.left
          parent_klass = klass
          klass = relationship.resource_klass
          pluck_attrs << table[klass._primary_key]
        end
        next unless non_polymorphic

        # Pre-fill empty hashes for each resource up to the end of the path.
        # This allows us to later distinguish between a preload that returned nothing
        # vs. a preload that never ran.
        prefilling_resources = resources.values
        path.each do |rel_name|
          rel_name = serializer.key_formatter.format(rel_name)
          prefilling_resources.map! do |res|
            res.preloaded_fragments[rel_name] ||= {}
            res.preloaded_fragments[rel_name].values
          end
          prefilling_resources.flatten!(1)
        end

        pluck_attrs << table[klass._cache_field] if klass.caching?
        relation = relation.joins(ar_hash)
        if relationship.is_a?(JSONAPI::Relationship::ToMany)
          # Rails doesn't include order clauses in `joins`, so we have to add that manually here.
          # FIXME Should find a better way to reflect on relationship ordering. :-(
          relation = relation.order(parent_klass._model_class.new.send(assocs_path.last).arel.orders)
        end

        # [[post id, comment id, author id, author updated_at], ...]
        id_rows = pluck_arel_attributes(relation.joins(ar_hash), *pluck_attrs)

        target_resources[klass.name] ||= {}

        if klass.caching?
          sub_cache_ids = id_rows
            .map{|row| row.last(2) }
            .reject{|row| target_resources[klass.name].has_key?(row.first) }
            .uniq
          target_resources[klass.name].merge! JSONAPI::CachedResourceFragment.fetch_fragments(
            klass, serializer, context, sub_cache_ids
          )
        else
          sub_res_ids = id_rows
            .map(&:last)
            .reject{|id| target_resources[klass.name].has_key?(id) }
            .uniq
          found = klass.find({klass._primary_key => sub_res_ids}, context: options[:context])
          target_resources[klass.name].merge! found.map{|r| [r.id, r] }.to_h
        end

        id_rows.each do |row|
          res = resources[row.first]
          path.each_with_index do |rel_name, index|
            rel_name = serializer.key_formatter.format(rel_name)
            rel_id = row[index+1]
            assoc_rels = res.preloaded_fragments[rel_name]
            if index == path.length - 1
              # HACK: JR originally did this:
              #   assoc_rels[rel_id] = target_resources[klass.name].fetch(rel_id)
              # Which throws an error when the fetch fails.  Causing a 500 error.
              # So we switched to this more permissive system... but then had to
              # tack on the .compact! a few lines down there \/ because otherwise
              # serialization fails due to a method call on nil.
              assoc_rels[rel_id] = target_resources[klass.name][rel_id]
            else
              res = assoc_rels[rel_id]
            end
            assoc_rels.compact!
          end
        end
      end
    end
    # rubocop:enable all
  end
end
