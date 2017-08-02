class FloatFormatter
  def self.[](precision)
    Class.new(self) { @precision = precision }
  end

  def self.format(value)
    value.to_f.round(@precision || 4)
  end
end
