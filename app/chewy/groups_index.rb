class GroupsIndex < Chewy::Index
  define_type Group do
    field :name
    field :about
    field :locale
    field :tagline
    field :category, value: ->(g) { g.category.name }
  end
end
