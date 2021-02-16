class Mutations::Namespace < Types::BaseObject
  def self.default_graphql_name
    "#{name.split('::')[1..-1].join}Mutations"
  end
end
