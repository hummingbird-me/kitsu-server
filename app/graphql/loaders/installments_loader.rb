class Loaders::InstallmentsLoader < Loaders::FancyLoader
  from Installment

  sort :release_order
  sort :alternative_order
end
