class Types::BaseObject < GraphQL::Schema::Object
  def self.batch_load_field(name, *args, association_name: nil, **kwargs, &block)
    if instance_methods(false).exclude?(name)
      define_method name do
        AssociationLoader.for(object.class, association_name.presence || name).load(object)
      end
    end

    field(name, *args, **kwargs, &block)
  end
end
