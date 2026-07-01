# frozen_string_literal: true

# Rails 8.1 removed the class-level `ActiveSupport::Deprecation` API (`.warn`,
# `.deprecation_warning`, etc.). Several still-maintained dependencies
# (jsonapi-resources, paranoia, ancestry, kaminari, rails_admin, chewy's
# transitive callers, ...) continue to call `ActiveSupport::Deprecation.warn`
# directly. Without this shim those calls fall through to the private
# `Kernel#warn` and raise NoMethodError.
#
# We delegate the legacy class-level calls to a shared deprecator instance so
# the deprecation messages are still surfaced through the normal channels.
module ActiveSupportDeprecationClassCompat
  def default_deprecator
    @default_deprecator ||= ActiveSupport::Deprecation.new
  end

  def warn(message = nil, callstack = nil)
    callstack ||= caller_locations(1)
    default_deprecator.warn(message, callstack)
  end

  def deprecation_warning(deprecated_method_name, message = nil, caller_backtrace = nil)
    default_deprecator.deprecation_warning(deprecated_method_name, message, caller_backtrace)
  end
end

unless ActiveSupport::Deprecation.respond_to?(:default_deprecator)
  ActiveSupport::Deprecation.singleton_class.prepend(ActiveSupportDeprecationClassCompat)
end
