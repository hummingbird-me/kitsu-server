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
      # @return [User] the user created by this
      def run!(force: false, target_user: nil)
        # Import the profile data
        user = import_profile(force: force, target_user: target_user)
        user_id = user.id
        # Import the library if they don't have an existing library
        if force || LibraryEntry.where(user_id: user_id).empty?
          import_library_to(user_id)
        end
        # Join the Aozora groups, giving mod rank to any Aozora admins
        join_groups(user_id, rank: (@user.admin? ? :mod : :pleb))
        # Import their follows
        Zorro::FollowImportWorker.perform_async(user_id)
        # Return the user
        user
      end

      # Import all users
      def self.run!
        # Autoloading constants has issues in a multi-threaded environment, so we need this
        Rails.application.eager_load!
        MongoProcessor.new(detailed_users).each do |user|
          Chewy.strategy(:bypass)
          new(user).run!
        end
      end

      # Import the profile
      #
      # @param force [Boolean] whether to forcibly overwrite existing Kitsu data with Aozora data
      # @return [User] the Kitsu user affected by this import
      def import_profile(force: false, target_user: nil)
        @profile ||= Zorro::Importer::ProfileImporter.new(
          @user_doc,
          target_user: target_user
        ).run!(force: force)
      end

      # Import the library data
      #
      # @param user_id [Integer] the Kitsu User ID to apply the import to
      # @return [ListImport::Aozora] the list import task generated for this user
      def import_library_to(user_id)
        ListImport::Aozora.create!(user_id: user_id, strategy: :obliterate, input_text: @user.id)
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
        TimelineFeed.new(user_id).follow_many(Group.where(id: new_groups).map(&:feed))
      end

      # Generates an aggregation which joins UserDetails data into the User collection
      # @private
      def self.detailed_users
        Zorro::DB::User.find.batch_size(2000).aggregate([
          {
            '$addFields': {
              detailsId: {
                '$substrBytes': ['$_p_details', 12, 10]
              }
            }
          },
          {
            '$lookup': {
              from: 'UserDetails',
              localField: 'detailsId',
              foreignField: '_id',
              as: 'details'
            }
          },
          {
            '$addFields': {
              details: {
                '$arrayElemAt': ['$details', 0]
              }
            }
          },
          {
            '$project': {
              detailsId: false
            }
          }
        ])
      end
    end
  end
end
