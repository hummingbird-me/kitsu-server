class Wordfilter < ApplicationRecord
  flag :locations, %i[post comment reaction]
  enum action: {
    censor: 10,
    report: 20,
    hide: 30,
    reject: 40
  }, _prefix: 'action_'

  validates :pattern, presence: true

  scope :matching, ->(text) {
    # Match regexes with ~* and create an exact match via ILIKE
    where("? ~* ('.*' || pattern || '.*')", text).where(regex_enabled: true).or(
      where("? ILIKE ('%' || pattern || '%')", text).where(regex_enabled: false)
    )
  }

  def self.action_for(location, text)
    matching(text).where_locations(location).order(action: :desc).first&.action&.to_sym
  end
end
