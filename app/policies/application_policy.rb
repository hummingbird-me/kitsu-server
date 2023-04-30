# Base class for all policies.  Provides a bunch of useful shortcuts for checks
# that we use frequently, such as checking for admin-ness, lewd goggles, or
# token scopes.
#
# Because of overlap between Pundit, Doorkeeper, and Rolify terminology,
# there are three different meanings of "scope", depending on context.
# Generally this should be obvious, but there may be scenarios when you need to
# reference the docs to understand.
#
# @abstract
# @attr_reader [User, nil] user the current user, if token is valid and refers
#   to a user
# @attr_reader [Object] record the record to authorize access to
# @attr_reader [Doorkeeper::AccessToken, nil] token the token provided by the
#   client to authenticate the request
class ApplicationPolicy
  attr_reader :user, :record, :token

  # Initialize a policy with a token and record.
  #
  # Generally, Pundit takes a `user` instead of a `token`, but to make OAuth2
  # scope handling simpler, we pass in `token` instead and then manually look
  # up the `user` based on that.  This allows us to put scope handling in the
  # Policy layer instead of up at the Resource or Controller layer, simplifying
  # logic and centralizing all authorization code in one place.
  #
  # TL;DR we use Pundit in weird ways
  def initialize(token, record)
    @token = token
    @record = record
    @user = token&.resource_owner
  end

  # By default, resources are visible to everybody
  def index?
    true
  end

  # By default, resources are not editable except by admins
  def edit?
    can_administrate?
  end
  alias_method :create?, :edit?
  alias_method :update?, :edit?
  alias_method :destroy?, :edit?

  # We don't have a #show? method because Pundit-Resources does not use them.
  # Instead, we use Pundit Scopes (see ApplicationPolicy::Scope)

  # @return [ApplicationPolicy::Scope] a utility class for applying a scope to
  #   an ActiveRecord::Relation based on the token + record
  def scope(base = record.class)
    Pundit.policy_scope!(token, base)
  end

  # Check if the user can see NSFW stuff
  #
  # @return [Boolean] Whether a user has their lewd goggles enabled
  def see_nsfw?
    user ? !user.sfw_filter? : false
  end

  # Check if the token provides a scope.
  #
  # When the token has the magical :all scope, this will always return true.
  #
  # @param [Symbol, String] *scopes A list of scopes which allow access to the
  #   requested resource.
  # @return [Boolean] Whether the current token provides the scope requested
  def has_scope?(*scopes, accept_all: true)
    acceptable = scopes
    acceptable += [:all] if accept_all
    token&.acceptable?(acceptable)
  end

  # Demand that the token provide a scope, raising an error and halting the
  # request if it's missing.
  #
  # @param [Symbol, String] *scopes A list of scopes which allow access to the
  #   requested resource.
  # @raise [OAuth::ForbiddenTokenError]
  def require_scope!(*scopes)
    raise OAuth::ForbiddenTokenError.for_scopes(scopes) unless has_scope?(*scopes)
  end

  # Check the record.user association to see if it's owned by the current user.
  #
  # @return [Boolean] Whether the current user is the owner of the record
  def is_owner? # rubocop:disable Style/PredicateName
    return false unless user && record.respond_to?(:user)
    return false unless record.user_id == user.id
    return false if record.user_id_was && record.user_id_was != user.id
    true
  end

  # Check whether there's a block between two users (in either direction)
  #
  # @return [Boolean] Whether there's a block between the two users
  def is_blocked?(user_a, user_b) # rubocop:disable Style/PredicateName
    Block.between(user_a, user_b).exists?
  end

  # Check if the user has an administrative permission
  #
  # @return [Boolean] whether the user has that permission
  def has_permission?(permission)
    user&.permissions&.set?(permission)
  end

  def can_administrate?
    false
  end

  def show?
    record_scope = record.class.where(id: record.id)
    scope(record_scope).exists?
  end

  %i[dashboard? export? history? show_in_app?].each do |action|
    define_method(action) { has_permission?(:database_mod) }
  end

  def new?
    can_administrate?
  end

  # Get a policy instance for a different object, so we can delegate to it.
  #
  # @return [ApplicationPolicy] The policy instance for this object
  def policy_for(model)
    Pundit.policy!(token, model)
  end

  def self.administrated_by(permission)
    define_method(:can_administrate?) do
      has_permission?(permission)
    end
    Scope.define_method(:can_administrate?) do
      has_permission?(permission)
    end
  end

  # Provide access control and act as #show?
  class Scope
    attr_reader :user, :scope, :token

    def initialize(token, scope)
      @token = token
      @scope = scope
      @user = token&.resource_owner
    end

    # Check if the user has an administrative permission
    #
    # @return [Boolean] whether the user has that permission
    def has_permission?(permission)
      user&.permissions&.set?(permission)
    end

    def can_administrate?
      false
    end

    def resolve
      scope
    end

    def blocked_users
      Block.hidden_for(user)
    end

    def see_nsfw?
      user ? !user.sfw_filter? : false
    end
  end

  class AlgoliaScope
    attr_reader :user, :token

    def initialize(token)
      @token = token
      @user = token&.resource_owner
    end

    def resolve
      ''
    end

    def blocked_users
      Block.hidden_for(user)
    end

    def see_nsfw?
      user ? !user.sfw_filter? : false
    end
  end
end
