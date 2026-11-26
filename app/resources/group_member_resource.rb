class GroupMemberResource < BaseResource
  include SortableByFollowing
  include GroupActionLogger

  attributes :rank, :unread_count, :hidden

  filter :rank, apply: ->(records, values, _options) {
    ranks = GroupMember.ranks.values_at(*values).compact
    ranks = values if ranks.empty?
    records.where(rank: ranks)
  }

  filters :group, :user

  has_one :group
  has_one :user
  has_many :permissions
  has_many :notes

  index UsersIndex::GroupMember
  query :query_group, apply: ->(values, _ctx) {
    { term: { group_id: values.join(' ') } }
  }
  query :query_user, apply: ->(values, _ctx) {
    { term: { user_id: values.join(' ') } }
  }
  query :query_rank, apply: ->(values, _ctx) {
    { match: { rank: values.join(' ') } }
  }
  query :group_category
  query :group_name,
    mode: :query,
    apply: ->(values, _ctx) {
      {
        match: {
          group_name: {
            query: values.join(' '),
            fuzziness: 2,
            max_expansions: 15,
            prefix_length: 1
          }
        }
      }
    }
  query :query,
    mode: :query,
    apply: ->(values, _ctx) { # rubocop:disable Metrics/BlockLength
      {
        bool: {
          should: [
            {
              multi_match: {
                fields: %w[name^4 past_names],
                query: values.join(' '),
                fuzziness: 2,
                max_expansions: 15,
                prefix_length: 1
              }
            },
            {
              multi_match: {
                fields: %w[name^4 past_names],
                query: values.join(' '),
                boost: 10
              }
            },
            {
              match_phrase_prefix: {
                name: values.join(' ')
              }
            }
          ]
        }
      }
    }

  # With the flag on, the filters below answer these from the database instead of Elasticsearch
  def self.searchable?
    super && !Flipper[:sql_group_member_search].enabled?(User.current)
  end

  # These go through subqueries rather than joins: an extra join makes jsonapi-resources read the
  # ids of included records from the wrong table.
  filter :query_group, apply: ->(records, values, _options) { records.where(group_id: values) }
  filter :query_user, apply: ->(records, values, _options) { records.where(user_id: values) }
  filter :query_rank, apply: ->(records, values, _options) { records.where(rank: values) }
  filter :group_category, apply: ->(records, values, _options) {
    records.where(group: Group.where(category: GroupCategory.where(slug: values)))
  }
  filter :group_name, apply: ->(records, values, options) {
    search_name(records, Group, :group_id, values, options)
  }
  filter :query, apply: ->(records, values, options) {
    search_name(records, User, :user_id, values, options)
  }

  # ponytail: ILIKE with no index reads every name it has to consider, which is slow for the very
  # largest groups. Add a trigram index on the name (pg_trgm is already enabled) if that hurts.
  def self.search_name(records, model, key, values, options)
    name = values.join(' ')
    named = model.where('name ILIKE ?', "%#{model.sanitize_sql_like(name)}%")
    records = records.where(key => named.select(:id))
    return records if options[:sort_criteria].present?

    # Nobody asked for an order, so put the closest matches first like a search would
    own_name = model.where("id = group_members.#{key}").select(:name).to_sql
    records.order([Arel.sql("similarity((#{own_name}), ?) DESC"), name])
  end

  # Elasticsearch sorted ranks by name, so ascending started with admins and the clients were built
  # around that. In the database admin is the highest rank, so the direction is reversed to match.
  def self.apply_sort(records, order_options, context = {})
    return super if searchable?

    reversed = { 'asc' => :desc, 'desc' => :asc }
    order_options = order_options.to_h do |field, direction|
      [field, field == 'rank' ? reversed[direction.to_s] : direction]
    end
    super(records, order_options, context)
  end

  def self.sortable_fields(context)
    super(context) << :'group.last_activity_at'
  end

  log_verb do |action|
    'kicked' if action == :destroy
  end
  log_target :user
end
