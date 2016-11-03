module ScopelessResource
  extend ActiveSupport::Concern

  # Override apply_pundit_scope to disable it
  def apply_pundit_scope(records)
    records
  end
end
