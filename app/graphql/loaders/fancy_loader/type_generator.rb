##
# Generate parameter types for sorting
class Loaders::FancyLoader::TypeGenerator
  class SortDirection < GraphQL::Schema::Enum
    graphql_name 'SortDirectionEnum'

    value :ASCENDING, value: :asc
    value :DESCENDING, value: :desc
  end

  def initialize(loader, name: loader.model.name)
    @loader = loader
    @name = name
  end

  def sorts_enum
    @sorts_enum ||= begin
      sorts = @loader.sorts
      name = "#{@name}SortEnum"

      Class.new(GraphQL::Schema::Enum) do
        graphql_name name
        sorts.each_key do |sort_name|
          value(sort_name.to_s.underscore.upcase, value: sort_name)
        end
      end
    end
  end

  def sorts_option
    @sorts_option ||= begin
      enum = sorts_enum
      name = "#{@name}SortOption"

      Class.new(GraphQL::Schema::InputObject) do
        graphql_name name
        argument :on, enum, required: true
        argument :direction, Types::Enum::SortDirection, required: true
      end
    end
  end

  def sorts_list
    @sorts_list ||= GraphQL::Schema::List.new(sorts_option)
  end
end
