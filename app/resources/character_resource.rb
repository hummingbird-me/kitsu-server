class CharacterResource < BaseResource
  attributes :slug, :names, :canonical_name, :other_names, :name, :mal_id, :description
  attribute :image, format: :shrine_attachment, delegate: :image_attacher

  has_one :primary_media, polymorphic: true
  has_many :castings
  has_many :media_characters
  has_many :quotes

  filter :slug

  index CharactersIndex::Character
  query :name,
    mode: :query,
    apply: ->(values, _ctx) {
      CharactersIndex::Character.query_for(values.join(' '))
    }

  def description
    html = Nokogiri::HTML.fragment(_model.description['en'])
    html.css('data, source').remove
    html.to_html
  end

  def name
    _model.canonical_name
  end

  def name=(value)
    _model.names['en'] = value
  end
end
