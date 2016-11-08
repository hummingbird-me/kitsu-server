class LibraryIndex < Chewy::Index
  define_type LibraryEntry.includes(:media) do
    root date_detection: false do
      include IndexTranslatable

      # Titles
      translatable_field :titles, value: -> (e) { e.media.titles }
      field :abbreviated_titles,
        type: 'string',
        value: -> (e) { e.media.abbreviated_titles }
      field :status, type: 'string'
      field :media_type, type: 'string'
      field :progress, type: 'integer'
      field :notes, type: 'string'
      field :updated_at, type: 'date'
      field :user_id, type: 'integer'
    end
  end
end
