class PersonResource < BaseResource
  attributes :name, :mal_id, :description
  attribute :image, format: :shrine_attachment, delegate: :image_attacher

  has_many :castings
  has_many :staff
  has_many :voices

  def mal_id
    'Moved to mappings relationship.'
  end

  def description
    _model.description['en']
  end
end
