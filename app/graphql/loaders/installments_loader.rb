class Loaders::InstallmentsLoader < Loaders::FancyLoader
  from Installment
  modify_query ->(query) {
    release_rank = Loaders::FancyLoader::RankQueryGenerator.new(
      :release_order,
      @find_by,
      table
    ).arel
    alternative_rank = Loaders::FancyLoader::RankQueryGenerator.new(
      :alternative_order,
      @find_by,
      table
    ).arel

    query.project(release_rank).project(alternative_rank)
  }

  sort :release_order
  sort :alternative_order
end
