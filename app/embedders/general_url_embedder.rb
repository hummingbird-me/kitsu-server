class GeneralUrlEmbedder < Embedder
  def to_h
    {
      kind: 'link',
      url: url,
      title: url
    }
  end

  def match?
    true
  end
end
