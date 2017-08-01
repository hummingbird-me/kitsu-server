module OnDestroyReparent
  extend ActiveSupport::Concern

  class_methods do
    def on_destroy_reparent(association, to_id:)
      association = reflections[association.to_s]

      if association.inverse_of.polymorphic?
        raise ArgumentError, 'on_destroy_reparent does not support polymorphic associations'
      end

      before_destroy do
        send(association).update_all(association.foreign_key => to_id)
      end
    end
  end
end
