class LinkedProfileResource < BaseResource
  attribute :token
  attributes :external_user_id, :url, :share_to, :share_from

  has_one :user
  has_one :linked_site

  filter :self, apply: -> (records, _v, options) {
    current_user = options[:context][:user]
    records.where(id: current_user&.id) || User.none
  }

  def fetchable_fields
    if current_user == _model
      super
    else
      super - [:token]
    end
  end
end
