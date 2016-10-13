class UserResource < BaseResource
  PRIVATE_FIELDS = %i[email password].freeze

  attributes :name, :past_names, :about, :bio, :about_formatted, :location,
    :website, :waifu_or_husbando, :to_follow, :followers_count, :created_at,
    :following_count, :onboarded, :life_spent_on_anime, :birthday, :gender
  attributes :avatar, :cover_image, format: :attachment
  attributes(*PRIVATE_FIELDS)

  has_one :waifu

  filter :name, apply: -> (records, value, _o) { records.by_name(value.first) }
  filter :self, apply: -> (_r, _v, options) {
    current_user = options[:context][:user]
    records.where(id: current_user.try(:id)) || User.none
  }

  def fetchable_fields
    if current_user == _model
      super
    else
      super - PRIVATE_FIELDS
    end
  end
end
