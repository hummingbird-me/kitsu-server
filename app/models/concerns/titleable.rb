module Titleable
  extend ActiveSupport::Concern

  included do
    with_options if: ->(obj) { obj.titles.present? } do
      validates :canonical_title, presence: true
      validate :has_english_title
    end
  end

  def canonical_title
    titles[self[:canonical_title]]
  end

  def canonical_title_key
    self[:canonical_title]
  end

  private

  def has_english_title?
    titles.keys.any? { |k| k.start_with?('en') }
  end

  def has_english_title
    errors.add(:titles, 'must have at least one english title') unless has_english_title?
  end
end
