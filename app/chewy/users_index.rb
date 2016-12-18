class UsersIndex < Chewy::Index
  class << self
    def blocking(*user_ids)
      filter { _id(:or) != user_ids }
    end
  end
  define_type User do
    field :name
    field :past_names
    field :updated_at
  end
end
