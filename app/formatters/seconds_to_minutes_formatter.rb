class SecondsToMinutesFormatter
  def self.format(value)
    value / 60 if value.present?
  end
end
