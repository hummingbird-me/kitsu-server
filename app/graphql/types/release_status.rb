class Types::ReleaseStatus < Types::BaseEnum
  value 'TBA', 'The release date has not been announced yet', value: :tba
  value 'FINISHED', 'This media is no longer releasing', value: :finished
  value 'CURRENT', 'This media is currently releasing', value: :current
  value 'UPCOMING', 'This media is releasing soon', value: :upcoming
  value 'UNRELEASED', 'This media is not released yet', value: :unreleased
end
