module FanoutOptional
  def no_fanout
    @no_fanout = true
    self
  end

  def stream_activity_target(opts = {})
    if @no_fanout
      super({ type: :aggregated }.merge(opts))
    else
      super(opts)
    end
  end
end
