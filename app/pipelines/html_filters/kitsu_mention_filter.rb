require 'html_pipeline/node_filter/mention_filter'

class HTMLFilters::KitsuMentionFilter < HTMLPipeline::NodeFilter::MentionFilter
  USERNAME_PATTERN = /[a-zA-Z0-9][a-zA-Z0-9_-]*/

  def after_initialize
    result[:mentioned_users] = []
  end

  def username_pattern
    USERNAME_PATTERN
  end

  # Check if user exists before we linkify it
  def link_to_mentioned_user(_base_url, login)
    user = User.by_slug(login).first || User.find_by(id: login)
    return unless user

    result[:mentioned_users] |= [user.id]

    url = "/users/#{user.slug || user.id}"
    %(<a href="#{url}" class="user-mention">@#{user.name}</a>)
  end
end
