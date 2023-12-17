class InstrumentedProcessor < JSONAPI::Processor
  %i[
    operation find show show_relationship show_related_resource show_related_resources
    create_resource remove_resource replace_fields replace_to_one_relationship
    create_to_many_relationships replace_to_many_relationships remove_to_many_relationships
    remove_to_one_relationship replace_polymorphic_to_one_relationship
  ].each do |event_name|
    set_callback(event_name, :around) do |_, block|
      Sentry.with_child_span(op: "jsonapi.#{event_name}",
            description: "JSONAPI::Resources #{event_name}") do |span|
        block.call
      end
    end
  end
end