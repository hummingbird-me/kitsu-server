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
    @titles = titles.symbolize_keys
    @canonical_locale = canonical_locale.to_sym
    @alternatives = alternatives
    @original_languages = original_languages
    @original_countries = original_countries
  end

  # @return [{Symbol => String}] the titles keyed by locale
  def localized
    @titles
  end

  # @return [<String>] the list of alternative titles
  attr_reader :alternatives

  # @return [Symbol] the key of the canonical title in the localized titles hash
  attr_reader :canonical_locale

  # @return [Symbol, nil] the key of the romanized/romaji title in the localized titles hash
  def romanized_locale
    # HACK: this should use originalLanguages, but we can't easily use that until we switch to using
    # the en-t-ja style keys.  For now, this is the same bodge from the frontend.
    %i[en_cn en_kr en_jp].find { |key| @titles.key?(key) }
    if @titles.key?(:en_cn) then :en_cn
    elsif @titles.key?(:en_kr) then :en_kr
    elsif @titles.key?(:en_jp) then :en_jp
    end
  end

  # @return [Symbol, nil] the key of the original title of the media in the localized titles hash
  def original_locale
    # TODO: we should aim to resolve all cases where this is nil or uses the fallback logic
    preferred_key = "#{@original_languages.first}_#{@original_countries.first}".to_sym
    if @titles.key?(preferred_key) then preferred_key
    elsif @titles.key?(:ja_jp) then :ja_jp
    end
  end

  # @return [Symbol, nil] the key of the best-matching translated title of the media in the
  #   localized titles hash based on `I18n.fallbacks[I18n.locale]`
  def translated_locale
    I18n.fallbacks[I18n.locale].find { |locale| @titles.key?(locale) }
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
    @titles[canonical_locale]
  end

  # @return [String, nil] the romanized/romaji/transliterated title
  def romanized
    @titles[romanized_locale]
  end

  # @return [String, nil] the original title of the media
  def original
    @titles[original_locale]
  end

  # @return [String, nil] the title of the media, translated into your current locale
  def translated
    @titles[translated_locale]
  end
end
