module Titleable
  extend ActiveSupport::Concern

  included do
    with_options if: ->(obj) { obj.titles.present? } do
      validates :canonical_title, presence: true
      validate :has_english_title
    end
  end

  def first_title_for(list)
    list.each do |key|
      title = public_send("#{key}_title")
      return title if title.present?
    end
  end

  def canonical_title
    titles[canonical_title_key]
  end

  def canonical_title_key
    self[:canonical_title]
  end

  def romanized_title
    titles[romanized_title_key]
  end

  def romanized_title_key
    # HACK: this should use originalLanguages, but we can't easily use that until we switch to using
    # the en-t-ja style keys.  For now, this is the same bodge from the frontend.
    if titles.include?('en_cn') then 'en_cn'
    elsif titles.include?('en_kr') then 'en_kr'
    else 'en_jp'
    end
  end

  def original_title
    titles[original_title_key]
  end

  def original_title_key
    preferred_original_title_key = "#{original_languages.first}_#{original_countries.first}"
    if titles.include?(preferred_original_title_key) then preferred_original_title_key
    elsif titles.include?('ja_jp') then 'ja_jp'
    end
  end

  def localized_title_key
    I18n.fallbacks[I18n.locale].find { |locale|
      titles.include?(locale.to_s)
    }&.to_s
  end

  def localized_title
    titles[localized_title_key]
  end

  private

  def has_english_title?
    titles.keys.any? { |k| k.start_with?('en') }
  end

  def has_english_title
    errors.add(:titles, 'must have at least one english title') unless has_english_title?
  end
end
