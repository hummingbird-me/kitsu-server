class FormattersController < ApplicationController
  include Pundit
  skip_after_action :enforce_policy_use

  def format_content
    content_formatted = LongPipeline.call(params[:content])[:output].to_s
    render json: { content_formatted: content_formatted }
  end
end
