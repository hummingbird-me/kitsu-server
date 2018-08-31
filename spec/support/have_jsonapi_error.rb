RSpec::Matchers.define :have_jsonapi_error do |conditions|
  match do |obj|
    # For non-hash match params, build the match hash
    conditions = { detail: conditions } unless conditions.is_a?(Hash)
    conditions = conditions.deep_stringify_keys

    # Mangle into a Hash structure
    obj = Oj.load(obj) if obj.is_a?(String)
    obj = obj.deep_stringify_keys

    # Check the errors
    obj['errors']&.any? do |err|
      conditions.all? do |key, value|
        value === err[key]
      end
    end
  end
end
