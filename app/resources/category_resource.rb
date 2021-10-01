class CategoryResource < BaseResource
  attributes :title, :description, :total_media_count,
    :slug, :nsfw, :child_count

  has_one :parent, eager_load_on_include: false
  has_many :anime
  has_many :drama
  has_many :manga

  paginator :unlimited

  filters :slug, :nsfw
  filter :parent_id, apply: ->(records, value, _options) {
    queries = value.map { |v| records.children_of(v) }
    queries.inject { |r, q| r ? r.or(q) : q }
  }

  def description
    _model.description['en']
  end
end
