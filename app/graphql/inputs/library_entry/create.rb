class Inputs::LibraryEntry::Create < Inputs::Base
  argument :user_id, ID, required: true
  argument :media_id, ID, required: true
  argument :media_type, Types::Enum::MediaType, required: true
  argument :status, Types::Enum::LibraryEntryStatus, required: true

  argument :progress, Integer, required: false, default_value: 0
  argument :private, Boolean, required: false, default_value: false
  argument :notes, String, required: false
  argument :reconsume_count, Integer, required: false, default_value: 0
  argument :reconsuming, Boolean, required: false, default_value: false
  argument :volumes_owned, Integer, required: false, default_value: 0
  argument :rating, Integer, required: false
  argument :started_at, GraphQL::Types::ISO8601DateTime, required: false
  argument :finished_at, GraphQL::Types::ISO8601DateTime, required: false
end
