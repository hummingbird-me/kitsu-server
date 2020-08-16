class GroupCategoryResource < BaseResource
  attributes :name, :slug, :description

  filter :slug

  def description
    _model.description['en']
  end
end
