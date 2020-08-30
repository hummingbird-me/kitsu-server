class GraphQL::Analysis::AST::QueryComplexity::ScopedTypeComplexity
  def own_complexity(child_complexity)
    defined_complexity = @field_definition.complexity

    if @field_definition.connection?
      (connection_argument_value * defined_complexity) + child_complexity
    elsif custom_field_definition_type?
      defined_complexity + child_complexity
    else
      child_complexity
    end
  end

  private

  def connection_argument_value
    argument = @node.arguments.find { |arg| %w(first last).include?(arg.name) }

    if argument.nil?
      raise GraphQL::AnalysisError, "Connection '#{@field_definition.name}' requires the argument 'first' or 'last' to be supplied."
    elsif !argument.value.between?(1, 100)
      raise GraphQL::AnalysisError, "Connection '#{@field_definition.name}' argument '#{argument.name}' must be between 1 - 100."
    else
      argument.value
    end
  end

  def custom_field_definition_type?
    return false if @field_definition.name == 'nodes'
    return true if @field_definition.type.try(:of_type).to_s.starts_with?('Types')

    false
  end
end
