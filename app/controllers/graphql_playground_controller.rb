class GraphqlPlaygroundController < ApplicationController
  skip_after_action :enforce_policy_use

  def show; end
end
