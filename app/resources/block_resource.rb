class BlockResource < BaseResource
  has_one :user
  has_one :blocked

  filter :user

  def records_for(relation_name)
    return super unless relation_name == :user
    _model.public_send relation_name
  end

  def self.preload_included_fragments(resources, records, serializer, options)
    super

    includes = options[:include_directives]&.include_directives
    blocked_included = includes&.dig(:include_related, :blocked, :include)

    return unless blocked_included

    # Manually load all blocked users
    blocked_ids = resources.values.map(&:blocked_id)
    blocked_users = User.find(blocked_ids).index_by(&:id)
    blocked_resources = blocked_users.transform_values do |user|
      UserResource.new(user, options[:context])
    end

    # Stuff them into the preloaded_fragments
    resources.each do |_id, res|
      res.preloaded_fragments['blocked'] = {
        res.blocked_id => blocked_resources[res.blocked_id]
      }
    end
  end
end
