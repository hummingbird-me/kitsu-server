class Loaders::MediaCategoriesLoader < Loaders::FancyLoader
  from MediaCategory

  sort :ancestry,
    transform: ->(ast) {
      ac = MediaCategory.arel_table
      c = Category.arel_table

      condition = ac[:category_id].eq(c[:id])

      ast.join(c, Arel::Nodes::OuterJoin).on(condition)
    },
    on: -> {
      c = Category.arel_table
      Arel::Nodes::NamedFunction.new(
        'concat',
        [c[:ancestry], Arel::Nodes.build_quoted('/'), c[:id]]
      )
    }
  sort :created_at
end
