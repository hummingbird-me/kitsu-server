module Titleable
  extend ActiveSupport::Concern

  included do
    with_options if: ->(obj) { obj.titles.present? } do
      validates :canonical_title, presence: true
      validates :romanized_title, presence: true, if: :romanized_title_key
      validates :original_title, presence: true, if: :original_title_key
      validate :has_english_title
    end
  end

  def titles_list
    TitlesList.new(
      titles: titles,
      canonical_locale: self[:canonical_title],
      original_locale: self[:original_title],
      romanized_locale: self[:romanized_title],
      alternatives: self[:abbreviated_titles] || []
    )
  end

  def canonical_title
    titles[canonical_title_key]
  end

  def canonical_title_key
    self[:canonical_title]
  end

  def original_title
    titles[original_title_key]
  end

  def original_title_key
    self[:original_title]
  end

  def romanized_title
    titles[romanized_title_key]
  end

  def romanized_title_key
    self[:romanized_title]
  end

  private

  def has_english_title?
    titles.keys.any? { |k| k.start_with?('en') }
  end

  def has_english_title
    errors.add(:titles, 'must have at least one english title') unless has_english_title?
  end
end
