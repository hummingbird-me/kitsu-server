class ListImportResource < BaseResource
  include STIResource

  model_hint model: ListImport::MyAnimeListXML
  model_hint model: ListImport::MyAnimeList
  model_hint model: ListImport::AnimePlanet
  model_hint model: ListImport::Anilist

  # Parameters
  attributes :input_text, :strategy
  attribute :input_file, format: :attachment
  # Status
  attributes :progress, :status, :total
  # Errors
  attributes :error_message, :error_trace

  has_one :user

  filters :user_id
end
