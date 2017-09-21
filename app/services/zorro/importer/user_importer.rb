module Zorro
  module Importer
    # Imports a user from the Aozora database into Kitsu, importing the profile and (if there's no
    # existing library entries) the library.
    class UserImporter
      # @param user [Hash] the user document from the Aozora database
      def initialize(user)
        @user_doc = user
        @user = Zorro::Wrapper::UserWrapper.new(user)
      end

      # Execute the import, optionally forcing an overwrite
      #
      # @param force [Boolean] whether to forcibly overwrite existing Kitsu data with Aozora data
      # @return [void]
      def run!(force: false)
        # Import the profile data
        user_id = import_profile(force: force).id
        # Import the library if they don't have an existing library
        import_library_to(user_id) if force || LibraryEntry.where(user_id: user_id).limit(1).blank?
        # Join the Aozora groups, giving mod rank to any Aozora admins
        join_groups(user_id, rank: (@user.admin? ? :mod : :pleb))
      end

      # Import all users
      def self.run!
        # Autoloading constants has issues in a multi-threaded environment, so we need this
        Rails.application.eager_load!
        MongoProcessor.new(Zorro::DB::User.find).each do |user|
          Chewy.strategy(:bypass)
          new(user).run!
        end
      end

      # Import the profile
      #
      # @param force [Boolean] whether to forcibly overwrite existing Kitsu data with Aozora data
      # @return [User] the Kitsu user affected by this import
      def import_profile(force: false)
        @profile ||= Zorro::Importer::ProfileImporter.new(@user_doc).run!(force: force)
      end

      # Import the library data
      #
      # @param user_id [Integer] the Kitsu User ID to apply the import to
      # @return [ListImport::Zorro] the list import task generated for this user
      def import_library_to(user_id)
        ListImport::Zorro.create!(user_id: user_id, strategy: :obliterate, input_text: @user.id)
      end

      # Join the Aozora groups
      #
      # @param user_id [Integer] the Kitsu User ID to have join the Aozora groups
      # @param rank [:pleb,:mod,:admin] the rank to give the user within the group
      def join_groups(user_id, rank: :pleb)
        existing_groups = GroupMember.where(user_id: user_id).pluck(:group_id)
        new_groups = (Groups.all_ids - existing_groups)
        rank = GroupMember.ranks[rank]
        members = new_groups.map do |group_id|
          [group_id, user_id, rank]
        end
        GroupMember.import(%i[group_id user_id rank], members, validate: false)
        TimelineFeed.new(user_id).follow_many(new_groups.map { |g| "group:#{g}" })
      end

      private

      # @return [User, nil] any existing Kitsu user with the same email
      def email_user
        @email_user ||= ::User.by_email(@user.email).first
      end
    end
  end
end
