class GraphQL::Analysis::AST::MaxQueryComplexity
  alias_method :original_result, :result

  def result
    original_result
  rescue GraphQL::AnalysisError => e
    GraphQL::AnalysisError.new(e.message)
  end
end
