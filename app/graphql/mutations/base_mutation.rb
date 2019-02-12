class Mutations::BaseMutation < GraphQL::Schema::Mutation
  include BehindFeatureFlag
end
