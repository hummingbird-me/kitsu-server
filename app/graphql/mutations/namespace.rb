class Mutations::Namespace < Types::BaseObject
  def self.default_graphql_name
    "#{name.split('::')[1..-1].join}Mutations"
  end

  # HACK: The GraphQL runtime gets confused by the nil objects in mutations. So we override the
  # object method to just return a hash with all fields being hashes.
  def object
    Hash.new { |hash, key| hash[key] = {} }
  end
end
