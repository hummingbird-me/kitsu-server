class WordfilterService
  def initialize(location, text)
    @location = location
    @text = text&.unicode_normalize
  end

  def reject?
    wordfilters[:reject].present?
  end

  def hide?
    wordfilters[:hide].present?
  end

  def report?
    wordfilters[:report].present?
  end

  def report_reasons
    wordfilters[:report]&.map(&:pattern)
  end

  def censor?
    wordfilters[:censor].present?
  end

  def censored_text
    wordfilters[:censor].inject(@text) do |text, wordfilter|
      # Convert SQL LIKE roughly into Regex
      pattern = if wordfilter.regex_enabled? then wordfilter.pattern
                else wordfilter.pattern.gsub('.', '\.').gsub('%', '.*').tr('_', '.')
                end
      pattern = Regexp.new(pattern, Regexp::IGNORECASE)

      text.gsub(pattern, 'CENSORED')
    end
  end

  private

  def wordfilters
    Wordfilter.where_locations(@location).matching(@text).group_by(&:action).symbolize_keys
  end
end
