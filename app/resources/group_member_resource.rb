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

  def self.sortable_fields(context)
    super(context) << :'group.last_activity_at'
  end

  log_verb do |action|
    'kicked' if action == :destroy
  end
  log_target :user
end
