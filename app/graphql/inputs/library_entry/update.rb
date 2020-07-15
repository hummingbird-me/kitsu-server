class Inputs::LibraryEntry::Update < Inputs::Base
  argument :id, ID, required: true

  argument :status, Types::Enum::LibraryEntryStatus, required: false
  argument :progress, Integer, required: false
  argument :private, Boolean, required: false
  argument :notes, String, required: false
  argument :reconsume_count, Integer, required: false
  argument :reconsuming, Boolean, required: false
  argument :volumes_owned, Integer, required: false
  argument :rating, Integer, required: false
  argument :started_at, GraphQL::Types::ISO8601DateTime, required: false
  argument :finished_at, GraphQL::Types::ISO8601DateTime, required: false
end
