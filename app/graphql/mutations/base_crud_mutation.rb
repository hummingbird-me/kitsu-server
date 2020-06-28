class Mutations::BaseCrudMutation < Mutations::BaseMutation
  def resolve(input:)
    public_send(action, input)
  rescue ActiveRecord::RecordNotFound => e
    Errors::RecordNotFound.graphql_error(e)
  end

  def create(input)
    record = model_klass.new(input.to_model)
    authorize record, authorize_action

    record.save

    if record.errors.any?
      errors(record)
    else
      { model_klass_key => record }
    end
  end

  def update(input)
    record = model_klass.find(input[:id])
    # authorize record, authorize_action

    record.update(input.to_model)

    if record.errors.any?
      { errors: errors(record) }
    else
      { model_klass_key => record }
    end
  end

  def delete(input)
    record = model_klass.find(input[:id])
    authorize record, authorize_action

    record.destroy

    if record.errors.any?
      { errors: errors(record) }
    else
      { model_klass_key => { id: record.id } }
    end
  end

  def errors(record)
    record.errors.map do |attribute, message|
      {
        path: ['attributes', attribute.to_s.camelize(:lower)],
        message: message
      }
    end
  end

  protected

  def authorize_action
    "#{action}?".to_sym
  end

  def action
    base_class.last.downcase
  end

  def model_klass
    base_class[1].constantize
  end

  def base_class
    @base_class ||= self.class.name.split('::')
  end

  private

  def model_klass_key
    model_klass.to_s.underscore
  end
end
