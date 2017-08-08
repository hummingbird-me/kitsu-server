class GroupResource < BaseResource
  include SluggableResource
  include GroupActionLogger

  caching

  attributes :about, :locale, :members_count, :name, :nsfw, :privacy, :rules,
    :rules_formatted, :leaders_count, :neighbors_count, :featured, :tagline,
    :last_activity_at
  attributes :avatar, :cover_image, format: :attachment

  filter :featured, verify: ->(values, _) {
    # If the values seem falsy, treat them as false.  Otherwise probably true.
    !(/false|f|0|no/ =~ values.join.downcase)
  }
  filter :category, verify: ->(values, _) {
    values.map do |v|
      GroupCategory.by_slug(v).or(GroupCategory.where(id: v)).first
    end
  }
  filter :privacy, apply: ->(records, values, _options) {
    privacies = Group.privacies.values_at(*values).compact
    privacies = values if privacies.empty?
    records.where(privacy: privacies)
  }

  has_many :members
  has_many :neighbors
  has_many :tickets
  has_many :invites
  has_many :reports
  has_many :leader_chat_messages
  has_many :action_logs
  has_one :category
  has_one :pinned_post

  after_create do
    # Make the current user into an owner when they create it
    member = _model.members.create!(user: actual_current_user)
    member.permissions.create!(permission: :owner)
  end

  index GroupsIndex::Group
  query :query,
    mode: :query,
    apply: ->(values, _ctx) {
      {
        bool: {
          should: [
            {
              multi_match: {
                fields: %w[name^4 tagline^2 about],
                query: values.join(' '),
                fuzziness: 2,
                max_expansions: 15,
                prefix_length: 1
              }
            },
            {
              multi_match: {
                fields: %w[name^4 tagline^2 about],
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

  log_verb do |action|
    next unless action == :update
    previous_changes.keys.map { |key|
      case key
      when 'avatar_updated_at' then 'avatar_changed'
      when 'cover_updated_at' then 'cover_changed'
      when 'locale' then 'locale_changed'
      when 'rules' then 'rules_changed'
      when 'nsfw' then 'nsfw_changed'
      when 'about' then 'about_changed'
      when 'tagline' then 'tagline_changed'
      when 'category_id' then 'category_changed'
      end
    }.compact
  end
  log_target []
  log_group []
end
