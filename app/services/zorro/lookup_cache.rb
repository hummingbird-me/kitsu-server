class Zorro
  class LookupCache
    def initialize(cache = ActiveSupport::Cache::MemoryStore.new)
      @cache = cache
    end

    def lookup(klass, *ids)
      ids = [ids].flatten
      # { 'abcdefjasfasdf' => 'User_abcdefjasfasdf'}
      klass_name = klass.name
      cache_keys = ids.map { |id| [id, key_for(klass_name, id)] }.to_h
      # Attempt to load all the keys from the cache
      found = @cache.read_multi(*cache_keys.values)
      # Find the cache misses
      missing_keys = cache_keys.reject { |_id, cache_key| found[cache_key] }
      # Load them
      klass.where(ao_id: missing_keys.keys).pluck(:ao_id, :id).each do |ao_id, id|
        cache_key = cache_keys[ao_id]
        found[cache_key] = id
        @cache.write(cache_key, id)
      end
      # Return the IDs
      ids.length == 1 ? cache_keys.values.first : cache_keys.values
    end

    private

    def key_for(klass, id)
      "ao_#{klass}_#{id}"
    end
  end
end
