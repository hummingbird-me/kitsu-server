module AuthorizedResource
  extend ActiveSupport::Concern

  include Pundit::Resource

  class_methods do
    def find(filters, options = {})
      super(filters, options).select { |resource| resource.send(:can, :show?) }
    end

    private

    def warn_if_show_defined; end
  end

  def records_for(association_name, options = {})
    context[:policy_used]&.call

    records = _model.public_send(association_name)
    apply_pundit_filter(apply_pundit_scope(records))
  end

  def apply_pundit_scope(records)
    return if records.nil?

    if records.respond_to?(:each)
      scope = Pundit.policy_scope!(current_user, records)
      records.merge(scope)
    elsif records.respond_to?(:id)
      scope = Pundit.policy!(current_user, records).scope
      records if scope.where(id: records.id).exists?
    end
  end

  def apply_pundit_filter(records)
    return if records.nil?

    if records.respond_to?(:each)
      records.to_a.select do |record|
        Pundit.policy!(current_user, record).show?
      end
    else
      records if Pundit.policy!(current_user, records).show?
    end
  end
end
