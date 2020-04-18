class DirtyChangeWrapper < SimpleDelegator
  def initialize(base, changes)
    super(base)
    @changes = changes

    changes.each do |key, (before, after)|
      define_singleton_method(key) { after }
      define_singleton_method("#{key}_was") { before }
      define_singleton_method("#{key}_changed?") { true }
      define_singleton_method("#{key}_change") { [before, after] }
    end
  end

  def method_missing(method_name, *args)
    case method_name
    when /_changed\?\z/ then false
    when /_change\z/ then nil
    when /_was\z/ then public_send(method_name.to_s.sub(/_was\z/, ''))
    else super
    end
  end

  def respond_to_missing?(method_name, _include_all)
    case method_name
    when /_changed\?\z/, /_change\z/, /_was\z/ then true
    else super
    end
  end
end
