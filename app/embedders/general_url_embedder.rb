class GeneralUrlEmbedder < Embedder
  def to_h
    { url: url }
  end

  def match?
    true
  end
end
