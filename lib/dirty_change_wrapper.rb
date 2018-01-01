class DirtyChangeWrapper < SimpleDelegator
  def initialize(base, changes)
    super(base)
    @changes = changes

    changes.each do |key, (before, after)|
      define_method(key) { after }
      define_method("#{key}_was") { before }
      define_method("#{key}_changed?") { true }
      define_method("#{key}_changes") { [before, after] }
    end
  end

  def method_missing(method_name)
    case method_name
    when /_changed?\z/ then false
    when /_changes\z/ then []
    else super
    end
  end

  def respond_to_missing?(method_name)
    case method_name
    when /_changed?\z/, /_changes\z/ then true
    else super
    end
  end
end
