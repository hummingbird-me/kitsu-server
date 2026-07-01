# frozen_string_literal: true

# jsonapi-resources 0.10.7 calls `Resource.new` / `SingletonResource.new` (from
# ActionDispatch routing) with the options hash as a 4th *positional* argument.
# Rails 8.1 changed these initializers to take keyword options only, so the
# legacy call raises `ArgumentError: wrong number of arguments (given 4,
# expected 3)` and silently breaks every `jsonapi_resources` route definition
# (leaving JSONAPI controllers without create/update/etc. routes).
#
# This shim normalizes a trailing positional Hash into keyword arguments.
module JsonapiResourcesRoutingCompat
  def initialize(entities, api_only = false, shallow = false, options = nil, **kwargs)
    if options.is_a?(Hash)
      super(entities, api_only, shallow, **options.symbolize_keys, **kwargs)
    else
      super(entities, api_only, shallow, **kwargs)
    end
  end
end

ActionDispatch::Routing::Mapper::Resources::Resource.prepend(JsonapiResourcesRoutingCompat)
ActionDispatch::Routing::Mapper::Resources::SingletonResource.prepend(JsonapiResourcesRoutingCompat)

# jsonapi-resources 0.9.x silently skipped relationship routes whose related
# resource class could not be found. 0.10.7 raises a NameError instead, which
# aborts the *entire* route set (leaving every JSONAPI controller unrouted).
# Restore the lenient behaviour so a single unmapped relationship can't take
# down all routing.
module JsonapiRelatedResourceCompat
  def jsonapi_related_resource(*relationship)
    super
  rescue NameError => e
    raise unless e.message.include?('Could not find resource')

    Rails.logger&.warn("[jsonapi compat] skipping related resource route: #{e.message}")
  end

  def jsonapi_related_resources(*relationship)
    super
  rescue NameError => e
    raise unless e.message.include?('Could not find resource')

    Rails.logger&.warn("[jsonapi compat] skipping related resources route: #{e.message}")
  end
end

ActionDispatch::Routing::Mapper.prepend(JsonapiRelatedResourceCompat)

