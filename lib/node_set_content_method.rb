module NodeSetContentMethod
  refine Nokogiri::XML::NodeSet do
    def content(*args)
      map { |node| node.content(*args) }&.join
    end
  end
end
