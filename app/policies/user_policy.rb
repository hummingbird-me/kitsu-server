class UserPolicy < ApplicationPolicy
  administrated_by :community_mod

  def create?
    true
  end

  def update?
    user == record || can_administrate?
  end
  alias_method :destroy?, :update?

  def editable_attributes(all)
    if has_scope?(:email_password_reset, accept_all: false)
      [:password]
    elsif has_scope?(:email_confirm, accept_all: false)
      [:confirmed]
    else
      all - %i[confirmed title pro_expires_at about_formatted comments_count favorites_count
               followers_count following_count import_from import_error import_status ip_addresses
               last_backup ratings_count rejected_edit_count reviews_count sign_in_count
               stripe_customer_id life_spent_on_anime ao_pro pro_tier]
    end
  end

  def visible_attributes(all)
    if record == user
      all
    else
      all - %i[email password confirmed previous_email language time_zone country share_to_global
               title_language_preference sfw_filter rating_system theme facebook_id apple_id
               has_password ao_pro]
    end
  end

  class Scope < Scope
    def resolve
      scope.active.blocking(blocked_users)
    end
  end

  class AlgoliaScope < AlgoliaScope
    def resolve
      blocked_users.map { |id| "id != #{id}" }.join(' AND ')
    end
  end
end
