class Inputs::BaseInputObject < GraphQL::Schema::InputObject
  alias_method :to_model, :to_h
end
