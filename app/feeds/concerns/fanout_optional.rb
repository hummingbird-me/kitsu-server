module FanoutOptional
  def no_fanout
    @no_fanout = true
    self
  end

  def write_target
    @no_fanout ? read_target : super
  end
end
