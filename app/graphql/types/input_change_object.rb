class Types::InputChangeObject < Types::BaseInputObject
  def as_json
    arguments.to_h.transform_values(&:as_json)
  end

  def self.subject(model)
    argument :id, ID, required: false

    define_method(:subject) do
      @subject ||= id ? model.find(id) : model.new
    end
  end

  def self.localized_field(name)
    argument "add_#{name}", Types::Map, required: false
    argument "remove_#{name}", [String], required: false

    define_method("apply_#{name}") do
      values = subject.public_send(name)
      values.merge!(public_send("add_#{name}")) if public_send("add_#{name}")
      values.except!(public_send("remove_#{name}")) if public_send("remove_#{name}")
      subject.public_send("#{name}=", values)
    end
  end

  def self.has_many(name, type) # rubocop:disable Naming/PredicateName
    argument :add_characters, [type], required: false
    argument :remove_characters, [ID], required: false

    define_method("apply_#{name}") do
      items = subject.public_send(name)
      items << public_send("add_#{name}").map(&:applied) if public_send("add_#{name}")
      items.delete(*public_send("remove_#{name}"))
      pp items
    end
  end
end
