class Types::Enum::LibraryEventKind < Types::Enum::Base
  value 'PROGRESSED', 'Progress or Time Spent was added/updated.', value: 'progressed'
  value 'UPDATED', 'Status or Reconsuming was added/updated.', value: 'updated'
  value 'REACTED', 'Reaction was added/updated.', value: 'reacted'
  value 'RATED', 'Rating was added/updated.', value: 'rated'
  value 'ANNOTATED', 'Notes were added/updated.', value: 'annotated'
end
