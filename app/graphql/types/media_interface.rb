module Types::MediaInterface
  include Types::BaseInterface
  description 'A media in the Kitsu database'

  field :id, ID, null: false
  field :slug, String,
    null: false,
    description: 'The URL-friendly identifier of this media'

  field :titles, Types::TitlesList,
    null: false,
    description: 'The titles for this media in various locales'

  field :synopsis, [Types::LocalizedString],
    null: false,
    description: 'A brief (mostly spoiler-free) summary/description of the media'

  field :age_rating, Types::AgeRating,
    null: true,
    description: 'The recommended minimum age group for this media'
  field :age_rating_guide, String,
    null: true,
    description: 'An explanation of why this received the age rating it did'

  field :start_date, Types::Date,
    null: true,
    description: 'The day that this media first released'
  field :end_date, Types::Date,
    null: true,
    description: 'the day that this media made its final release'
  field :next_release, GraphQL::Types::ISO8601DateTime,
    null: true,
    description: 'The time of the next release of this media'
  field :status, Types::ReleaseStatus,
    null: false,
    description: 'The current releasing status of this media'

  field :average_rating, Float,
    null: true,
    description: 'The average rating of this media amongst all Kitsu users'
  field :user_count, Integer,
    null: true,
    description: 'The number of users with this in their library'
  field :favorites_count, Integer,
    null: true,
    description: 'The number of users with this in their favorites'

  field :poster_image, Types::Image,
    null: false,
    description: 'The poster image of this media'

=begin
  field :poster_image, Types::Image,
    null: true,
    description: 'The poster image for the media'
  field :cover_image, Types::Image,
    null: true,
    description: 'The cover image for the media (not the poster image)'
=end

  def titles
    {
      localized: object.titles,
      alternatives: object.abbreviated_titles,
      canonical: object.canonical_title
    }
  end

  def synopsis
    # TODO: actually store more synopsis data than this
    [{ locale: 'en', text: object.synopsis }]
  end
end
