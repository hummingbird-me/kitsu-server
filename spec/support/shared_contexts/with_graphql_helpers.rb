# frozen_string_literal: true

RSpec.shared_context 'with graphql helpers' do
  def execute_query(query, **variables)
    KitsuSchema.execute(query, variables: variables, context: context || {})
  end
end
