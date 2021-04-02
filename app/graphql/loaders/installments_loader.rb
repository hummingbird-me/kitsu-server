class Loaders::InstallmentsLoader < Loaders::FancyLoader
  from Installment

  sort :release_position
  sort :chronological_position
end
