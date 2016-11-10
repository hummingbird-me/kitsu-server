class ListImportResource < BaseResource
  # Parameters
  attributes :input_text, :strategy, :kind
  attribute :input_file, format: :attachment
  # Status
  attributes :progress, :status, :total
  # Errors
  attributes :error_message, :error_trace

  has_one :user
end
