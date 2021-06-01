class ListImportResource < BaseResource
  include STIResource

  model_hint model: ListImport::MyAnimeListXML
  model_hint model: ListImport::MyAnimeList
  model_hint model: ListImport::AnimePlanet
  model_hint model: ListImport::Anilist
  model_hint model: ListImport::Aozora

  # Parameters
  attributes :input_text, :strategy
  attribute :input_file, format: :shrine_attachment
  # Status
  attributes :progress, :status, :total
  # Errors
  attributes :error_message, :error_trace

  has_one :user

  filters :user_id

  def input_file=(file)
    @model.input_file_data_uri = file
  end
end
