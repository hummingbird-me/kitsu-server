class LibraryEvent < ApplicationRecord
  belongs_to :library_entry, optional: false
  belongs_to :user, optional: false
  belongs_to :anime, optional: true
  belongs_to :manga, optional: true
  belongs_to :drama, optional: true

  enum kind: { progressed: 0, updated: 1, reacted: 2, rated: 3, annotated: 4 }
  validates :kind, presence: true

  # 2017 Toy had horrible naming conventions and 2017 Nuck approved shitty code of mine.
  # this filters by media_types NOT kind....
  scope :by_kind, ->(*kinds) do
    t = arel_table
    columns = kinds.map { |k| t[:"#{k}_id"] }
    scope = columns.shift.not_eq(nil)
    columns.each do |col|
      scope = scope.or(col.not_eq(nil))
    end
    where(scope)
  end

  def progress
    return if changed_data['progress'].nil?

    changed_data['progress'][1] - changed_data['progress'][0]
  end
end
