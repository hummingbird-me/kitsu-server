module Zorro
  module Groups
    GROUP_NAMES = %w[AoTalk AoNews AoMeme AoOfficial AoArt].freeze

    module_function

    # Set up all the Aozora groups in the Kitsu database
    def create!
      misc = GroupCategory.find_by(slug: 'misc').id
      GROUP_NAMES.each do |name|
        # Make the group
        group = Group.where(
          name: name
        ).first_or_create(category_id: misc)
        # Set up an initial owner
        GroupMember.create!(user: owner, group: group, rank: :admin)
      end

      # Build up neighborhood, so the aozora groups have each other as neighbors
      GROUP_NAMES.permutation(2) do |from, to|
        src = Group.find_by(name: from)
        dst = Group.find_by(name: to)
        GroupNeighbor.create!(source: src, destination: dst)
      end
    end

    # Define a bunch of shorthand methods such as ao_gur, ao_talk, etc. for referencing Aozora
    # groups quickly and easily
    GROUP_NAMES.each do |name|
      undername = name.underscore
      group_var = :"@group_#{undername}"
      define_method(undername) do
        return instance_variable_get(group_var) if instance_variable_defined?(group_var)
        instance_variable_set(group_var, Group.find_by(name: name))
      end
    end

    # @param [String] the name of a group in Aozora
    # @return [Group] the Aozora group with that name
    def by_name(name)
      # aoGur is, for some reason, not always consistently-cased, so we need to compare
      # case-insensitively.
      return ao_meme if name.casecmp?('aoGur')
      public_send(name.underscore)
    end

    # @return [ActiveRecord::Relation<Group>] all Aozora groups in the Kitsu DB
    def all
      Group.where(name: GROUP_NAMES)
    end

    # @return [Array<Integer>] IDs of all Aozora groups
    def all_ids
      @all_ids ||= all.ids
    end

    # @return [User] the user who should own the groups when they're created
    def owner
      @owner ||= User.find(2) # Josh
    end
  end
end
