class GroupCategoryResource < BaseResource
  attributes :name, :slug, :description

  filter :slug
end
