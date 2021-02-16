class Mutations::Manga::Create < Mutations::Base
  prepend RescueValidationErrors

  argument :input,
    Types::Input::Manga::Create,
    required: true,
    description: 'Create Manga',
    as: :manga

  field :manga, Types::Manga, null: true
  field :errors, [Types::Interface::Error], null: true

  def load_manga(value)
    ::Manga.new(value.to_h)
  end

  def authorized?(manga:)
    super(manga, :create?)
  end

  def resolve(manga:)
    manga.save!

    { manga: manga }
  end
end
