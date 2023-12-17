class InstrumentedProcessor < JSONAPI::Processor
  %i[
    operation find show show_relationship show_related_resource show_related_resources
    create_resource remove_resource replace_fields replace_to_one_relationship
    create_to_many_relationship replace_to_many_relationship remove_to_many_relationship
    remove_to_one_relationship
  ].each do |event_name|
    set_callback(event_name, :around) do |_, block|
      Sentry.with_child_span(op: "jsonapi.#{event_name}",
            description: "JSONAPI::Resources #{event_name}") do |span|
        span&.set_data(:record, value&.record&.to_global_id&.to_s)
        span&.set_data(:name, value&.name&.to_s)

        block.call
      end
    end
  end
end