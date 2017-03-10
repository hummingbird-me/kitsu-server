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

  after_create do
    # Make the current user into an owner when they create it
    member = _model.members.create!(user: actual_current_user)
    member.permissions.create!(permission: :owner)
  end

  index GroupsIndex::Group
  query :query,
    mode: :query,
    apply: -> (values, _ctx) {
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

  def self.sortable_fields(context)
    super(context) << :created_at
  end

  log_verb do |action|
    next unless action == :update
    next 'avatar_changed' if avatar_updated_at_changed?
    next 'cover_changed' if cover_image_updated_at_changed?
    next 'locale_changed' if locale_changed?
    next 'rules_changed' if rules_changed?
    next 'nsfw_changed' if nsfw_changed?
    next 'about_changed' if about_changed?
    next 'tagline_changed' if tagline_changed?
    next 'category_changed' if category_id_changed?
  end
  log_target []
  log_group []
end
