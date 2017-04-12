class UserSettingResource < BaseResource
  include STIResource

  attributes :value, :updated_at, :created_at

  has_one :user
end
