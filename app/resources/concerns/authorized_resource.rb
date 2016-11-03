module AuthorizedResource
  extend ActiveSupport::Concern

  include Pundit::Resource

  class_methods do
    def find(filters, options = {})
      records = find_records(filters, options)
      resources = resources_for(records, options[:context])
      resources.select { |resource| resource.send(:can, :show?) }
    end

    private

    def warn_if_show_defined; end
  end

  def records_for(association_name, options = {})
    super.to_a.select do |record|
      show?(Pundit.policy!(context[:current_user], record), record.id)
    end
  end

  private

  def show?(policy, record_id)
    policy.scope.where(id: record_id).exists? && policy.show?
  end
end
