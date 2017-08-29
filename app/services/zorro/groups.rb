module Zorro
  module Groups
    GROUP_NAMES = %w[AoTalk AoNews AoMeme AoOfficial AoArt].freeze

    module_function

    def create!
      # Set up groups
      misc = GroupCategory.find_by(slug: 'misc').id
      GROUP_NAMES.each do |name|
        Group.where(
          name: name
        ).first_or_create(category_id: misc)
      end

      # Build up neighborhood
      GROUP_NAMES.permutation(2) do |from, to|
        src = Group.find_by(name: from)
        dst = Group.find_by(name: to)
        GroupNeighbor.create!(source: src, destination: dst)
      end
    end

    GROUP_NAMES.each do |name|
      undername = name.underscore
      group_var = :"@group_#{undername}"
      define_method(undername) do
        return instance_variable_get(group_var) if instance_variable_defined?(group_var)
        instance_variable_set(group_var, Group.find_by(name: name))
      end
    end

    def by_name(name)
      return ao_meme if name == 'aoGur'
      public_send(name.underscore)
    end

    def owner
      @owner ||= User.find(2) # Josh
    end
  end
end
