# frozen_string_literal: true

# Encapsulates the title logic for a Media, making it much easier to work with.
class TitlesList
  # @param titles [{Symbol, String => String}] the titles in various locales
  # @param canonical_title_key [Symbol, String] the key of the canonical title in the titles hash
  # @param alternatives [<String>] the list of alternative titles
  # @param original_languages [<String>] the list of languages the media was originally released in
  # @param original_countries [<String>] the list of countries the media was originally released in
  def initialize(
    titles:,
    canonical_locale:,
    alternatives: [],
    original_languages: [],
    original_countries: []
  )
    @titles = titles
    @canonical_locale = canonical_locale
    @alternatives = alternatives
    @original_languages = original_languages
    @original_countries = original_countries
  end

  # @return [{Symbol => String}] the titles keyed by locale
  def localized
    @localized ||= @titles.transform_keys { |key| fix_locale_code(key) }
  end

  # @return [<String>] the list of alternative titles
  attr_reader :alternatives

  # @return [Symbol] the key of the canonical title in the localized titles hash
  def canonical_locale
    fix_locale_code(@canonical_locale)
  end

  # @return [Symbol, nil] the key of the romanized/romaji title in the localized titles hash
  def romanized_locale
    # HACK: this should use originalLanguages, but we can't easily use that until we switch to using
    # the en-t-ja style keys.  For now, this is the same bodge from the frontend.
    fix_locale_code(%w[en_cn en_kr en_jp].find { |key| @titles.key?(key) })
  end

  # @return [Symbol, nil] the key of the original title of the media in the localized titles hash
  def original_locale
    # TODO: we should aim to resolve all cases where this is nil or uses the fallback logic and then
    # add a validation to ensure it moving forward
    keys = @original_languages.product(@original_countries).map do |(lang, country)|
      "#{lang}_#{country}".downcase
    end

    # ja_jp is the fallback case for now
    fix_locale_code([*keys, 'ja_jp'].find { |key| @titles.key?(key) })
  end

  # @return [Symbol, nil] the key of the best-matching translated title of the media in the
  #   localized titles hash based on `I18n.fallbacks[I18n.locale]`
  def translated_locale
    fix_locale_code(I18n.fallbacks[I18n.locale].find { |locale| @titles.key?(locale.to_s) }&.to_s)
  end

  # Apply a title preference and get the first present title from it. Pass in an array of title
  # types based on the order you prefer them, first being highest priority. As long as you one of
  # the options is `:canonical` you can assume that this will not return nil, since there is always
  # a canonical title. In future, the `:original` option will provide a similar guarantee.
  #
  # @param preferences [<:canonical, :romanized, :original, :localized>] the preference list of
  #   titles to try
  # @return [String, nil] the first title in the preference list which is available
  def first_title_for(preferences)
    list = preferences & %i[canonical romanized original localized]
    list.each do |key|
      title = public_send(key)
      return title if title.present?
    end
  end

  # @return [String] the canonical title (whatever we judge to be the "common" title)
  def canonical
    localized[canonical_locale]
  end

  # @return [String, nil] the romanized/romaji/transliterated title
  def romanized
    localized[romanized_locale]
  end

  # @return [String, nil] the original title of the media
  def original
    localized[original_locale]
  end

  # @return [String, nil] the title of the media, translated into your current locale
  def translated
    localized[translated_locale]
  end

  private

  # HACK: we store with old shitty keys, so we need to convert them to the new ones for output
  def fix_locale_code(key)
    locale = key&.tr('_', '-')
    case locale
    when 'en-cn', 'en-ch' then 'en-t-zh'
    when 'en-kr', 'en-kn' then 'en-t-ko'
    when 'en-th' then 'en-t-th'
    when 'en-jp' then 'en-t-ja'
    else locale
    end
  end

  def available_locales
    @available_locales ||= PreferredLocale.new(available: localized.keys)
  end
end
