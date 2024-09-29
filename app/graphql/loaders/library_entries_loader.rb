# frozen_string_literal: true

class Loaders::LibraryEntriesLoader < GraphQL::FancyLoader
  from LibraryEntry
  sort :media_type
  sort :status
  sort :created_at
  sort :updated_at
  sort :progress
  sort :rating
  sort :started_at
  sort :finished_at
  sort :title,
    transform: ->(ast, _context) {
      ast.join(Anime.arel_table, Arel::Nodes::OuterJoin).on(
        LibraryEntry.arel_table[:media_id].eq(Anime.arel_table[:id]).and(
          LibraryEntry.arel_table[:media_type].eq(Arel::Nodes.build_quoted('Anime'))
        )
      ).join(Manga.arel_table, Arel::Nodes::OuterJoin).on(
        LibraryEntry.arel_table[:media_id].eq(Manga.arel_table[:id]).and(
          LibraryEntry.arel_table[:media_type].eq(Arel::Nodes.build_quoted('Manga'))
        )
      )
    },
    on: -> {
      title_preference_list = User.current&.title_preference_list || %i[canonical romanized translated]

      [Anime, Manga].reduce(Arel::Nodes::Case.new) do |sql_case, klass|
        table = klass.arel_table
        preferred_titles = title_preference_list.flat_map do |preference|
          case preference
          when :canonical
            Arel::Nodes::InfixOperation.new('->', table[:titles], table[:canonical_title])
          when :romanized
            Arel::Nodes::InfixOperation.new('->', table[:titles], table[:romanized_title])
          when :original
            Arel::Nodes::InfixOperation.new('->', table[:titles], table[:original_title])
          when :translated
            I18n.fallbacks[I18n.locale].map do |locale|
              locale = Arel::Nodes.build_quoted(locale.to_s)
              Arel::Nodes::InfixOperation.new('->', table[:titles], locale)
            end
          end
        end
        sql_case.when(
          LibraryEntry.arel_table[:media_type].eq(klass.name),
          Arel::Nodes::NamedFunction.new('COALESCE', preferred_titles.compact)
        )
      end
    }
end
