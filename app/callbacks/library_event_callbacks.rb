class LibraryEventCallbacks < Callbacks
  # @param klass [Class] the class to hook the callbacks for
  def self.hook(klass)
    klass.after_update(self)
  end

  def after_update
    LibraryEventService.new(record).create_events!
  end
end
