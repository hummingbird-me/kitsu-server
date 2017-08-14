class AlgoliaDateFormatter
  def self.format(value)
    value.to_time.to_i if value
  end
end
