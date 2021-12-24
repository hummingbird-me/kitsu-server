class UsersController < ApplicationController
  include CustomControllerHelpers

  def create
    if Flipper.enabled?(:registration)
      super
    else
      render_jsonapi_error(403, 'Registrations are closed')
    end
  end

  def recover
    query = params[:username]
    Accounts::SendPasswordReset.call(email: query)
    render json: { username: query }
  rescue Action::ValidationError
    render_jsonapi_error(400, 'No email provided')
  end

  def confirm
    token = Doorkeeper::AccessToken.by_token(params[:token])
    return render_jsonapi_error(403, 'Not Authorized') unless token&.acceptable?(:email_confirm)
    token.resource_owner.update(confirmed_at: Time.now)
    render json: { confirmed: true }
  end

  def unsubscribe
    query = params[:email]
    user = User.by_email(query).first
    user.update!(subscribed_to_newsletter: false)
    render json: { email: query }
  end

  def conflicts_index
    return render_jsonapi_error(403, 'Feature disabled') unless Flipper.enabled?(:aozora)
    conflict_detector = Zorro::UserConflictDetector.new(user: user)
    render json: conflict_detector.accounts
  end

  def conflicts_update
    return render_jsonapi_error(403, 'Feature disabled') unless Flipper.enabled?(:aozora)
    render_jsonapi_error 400, 'You must choose' unless params[:chosen].present?
    chosen = params[:chosen].to_sym
    conflict_resolver = Zorro::UserConflictResolver.new(user)
    user = conflict_resolver.merge_onto(chosen)
    render_jsonapi serialize_model(user)
  end

  def alts
    return render_jsonapi_error(401, 'Not permitted') unless user&.permissions&.community_mod?
    target_user = User.find(params[:id])
    ModeratorActionLog.generate!(user, 'viewed alts', target_user)
    alts = target_user.alts.map do |(u, weight)|
      {
        slug: u.slug,
        name: u.name,
        id: u.id,
        weight: weight
      }
    end
    render json: alts
  end

  def ban
    return render_jsonapi_error(401, 'Not permitted') unless user&.permissions&.community_mod?
    target_user = User.find(params[:id])
    ModeratorActionLog.generate!(user, 'banned', target_user)
    target_user.add_role(:banned)
    render json: { banned: true }
  end

  def unban
    return render_jsonapi_error(401, 'Not permitted') unless user&.permissions&.community_mod?
    target_user = User.find(params[:id])
    ModeratorActionLog.generate!(user, 'unbanned', target_user)
    target_user.remove_role(:banned)
    render json: { banned: false }
  end

  def destroy_content
    return render_jsonapi_error(401, 'Not permitted') unless user&.permissions&.community_mod?
    target_user = User.find(params[:id])
    kinds = Array.wrap(params[:kind])
    ModeratorActionLog.generate!(user, "destroyed #{kinds.join(', ')}", target_user)
    kinds.each do |kind|
      case kind
      when 'posts'
        target_user.posts.update_all(deleted_at: Time.now)
      when 'comments'
        target_user.comments.update_all(deleted_at: Time.now)
      when 'reactions'
        target_user.media_reactions.update_all(deleted_at: Time.now)
      end
    end
  end

  def flags
    user = current_user&.resource_owner
    features = Flipper.preload_all
    flags = features.map { |f| [f.name, f.enabled?(user)] }.to_h
    enabled_flags = flags.select { |_, enabled| enabled }
    render json: enabled_flags, status: 200
  end
end
