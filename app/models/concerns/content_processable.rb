module ContentProcessable
  extend ActiveSupport::Concern

  class_methods do
    def processable(column, pipeline)
      processed_column = "processed_#{column}"
      memoized = "@#{processed_column}"

      define_method(processed_column) do
        existing_value = instance_variable_get(memoized)
        return existing_value if existing_value

        processed_content = pipeline.call(public_send(column))
        instance_variable_set("@#{processed_column}".to_sym, processed_content)
        processed_content
      end

      before_validation do
        if public_send("#{column}_changed?")
          procssed_content = public_send(processed_column)[:output].to_s
          assign_attributes("#{column}_formatted" => procssed_content)
        end
      end
    end
  end
end
