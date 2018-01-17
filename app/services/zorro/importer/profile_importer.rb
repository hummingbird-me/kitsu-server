require_dependency 'zorro'

module Zorro
  module Importer
    # Imports a profile from Aozora to Kitsu
    class ProfileImporter
      # Import all users from the Aozora database
      def self.run!
        Zorro::DB::User.find.each do |user|
          yield user
          new(user).run!
        end
      end

      # @param user [Hash] the user document from Aozora's MongoDB server
      # @param target_user [User] the User instance to apply the merge onto
      def initialize(user, target_user: nil)
        @target_user = target_user
        @user = Zorro::Wrapper::UserWrapper.new(user)
      end

      # Run the import, pulling profile data from Aozora
      #
      # @param force [Boolean] whether to forcibly import the full profile and override Kitsu data
      # @return [User] the user which was affected by this import
      def run!(force: false)
        @user.initial_merge_onto(target_user)
        @user.full_merge_onto(target_user) if force || existing_user.nil?
        target_user.save(validate: false)
        target_user
      end

      private

      # @return [User] the user to import onto, either existing or new
      def target_user
        @target_user ||= (existing_user || ::User.new)
      end

      # @return [User, nil] any existing Kitsu user with the same email or ao_id
      def existing_user
        @existing_user ||= User.by_email(@user.email).or(User.where(ao_id: @user.id)).first
      end
    end
  end
end
