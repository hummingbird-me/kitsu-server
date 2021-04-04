class Loaders::InstallmentsLoader < Loaders::FancyLoader
  from Installment
  modify_query ->(query) {
    release_rank = Loaders::FancyLoader::RankQueryGenerator.new(
      column: :release_order,
      partition_by: @find_by,
      table: table
    ).arel
    alternative_rank = Loaders::FancyLoader::RankQueryGenerator.new(
      column: :alternative_order,
      partition_by: @find_by,
      table: table
    ).arel

    query.project(release_rank).project(alternative_rank)
  }

  sort :release_order
  sort :alternative_order
end
