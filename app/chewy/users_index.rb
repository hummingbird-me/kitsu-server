class UsersIndex < Chewy::Index
  index_scope User

  def self.blocking(*user_ids)
    filter(bool: { must_not: { ids: { values: user_ids.flatten } } })
  end

  def self.active
    filter(bool: { must_not: { exists: { field: :deleted_at } } })
  end

  field :name, type: 'text'
  field :past_names, type: 'text'
  field :updated_at
  field :deleted_at
end
