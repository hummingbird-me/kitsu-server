module ScopelessResource
  extend ActiveSupport::Concern

  def records_for(association_name)
    relationships = self.class._relationships.
      values.
      select { |r| r.relation_name(context: @context) == association_name }.
      uniq(&:class)

    unless relationships.count == 1
      raise "Can't infer relationship type for #{association_name}"
    end

    relationship = relationships.first

    context[:policy_used]&.call

    case relationship
    when JSONAPI::Relationship::ToMany
      records = _model.public_send(association_name)
      records.to_a.select do |record|
        Pundit.policy!(context[:current_user], record).show?
      end
    when JSONAPI::Relationship::ToOne
      record = _model.public_send(association_name)

      record if record && Pundit.policy!(context[:current_user], record).show?
    end
  end
end
