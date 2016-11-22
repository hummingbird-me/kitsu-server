class UserPolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    user == record || is_admin?
  end

  def destroy?
    is_admin?
  end

  def editable_attributes(all)
    if has_scope?(:email_password_reset, accept_all: false)
      [:password]
    elsif has_scope?(:email_confirm, accept_all: false)
      [:confirmed_at, :unconfirmed_email, :email]
    else
      all
    end
  end

  def visible_attributes(all)
    if record == user
      all
    else
      all - %i[email password confirmed_at unconfirmed_email]
    end
  end
end
