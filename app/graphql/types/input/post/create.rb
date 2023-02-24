class Types::Input::Post::Create < Types::Input::Base
  argument :content, String, required: true
  # argument :content_formatted, String, required: true
  argument :media_id, ID, required: false
  argument :media_type, Types::Enum::MediaType, required: false
  argument :is_spoiler, Boolean, required: false, default_value: false, as: :spoiler
  argument :is_nsfw, Boolean, required: false, default_value: false, as: :nsfw

  def to_model
    to_h.merge({ user_id: current_user&.id })
  end
end
