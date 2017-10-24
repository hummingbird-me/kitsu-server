module Zorro
  # Service for detecting user conflicts, logging a user in, and displaying conflicts
  class UserConflictDetector
    def initialize(email: nil, facebook_id: nil, ao_facebook_id: nil, user: nil)
      @email = email
      @facebook_id = facebook_id
      @ao_facebook_id = ao_facebook_id
      @user = user
    end

    # @return [Boolean] whether there's a conflict on the supplied credentials
    def conflict?
      accounts.count == 2
    end

    # @return [Hash] a hash of account information matching the supplied credentials
    def accounts
      out = {}
      out[:aozora] = aozora_user_info if aozora_user
      out[:kitsu] = kitsu_user_info if kitsu_user
      out
    end

    # Find a User (or import one from Aozora) for the given credentials.
    #
    # @return [User, nil] the User to log into, given the supplied credentials
    def user!
      if conflict? # Aozora & Kitsu
        # Update the User's ao_id and status to mark them as needing reonboarding
        kitsu_user.update!(ao_id: aozora_user['_id'], status: :aozora)
        kitsu_user
      elsif aozora_user.present? # Aozora-only
        imported_aozora_user || import_aozora_user!
      else # Kitsu-Only
        kitsu_user
      end
    end

    private

    # Imports the Aozora User
    def import_aozora_user!
      Zorro::Importer::UserImporter.new(aozora_user).run!(force: true, rush: true)
    end

    # @return [Hash] some basic info about the user on Kitsu
    def kitsu_user_info
      {
        name: kitsu_user.name,
        avatar: kitsu_user.avatar(:large),
        library_entries: kitsu_user.library_entries.count
      }
    end

    # @return [Hash] some basic info about the user on Aozora
    def aozora_user_info
      {
        name: aozora_user['aozoraUsername'],
        avatar: "https://aozora-assets.s3.amazonaws.com/#{aozora_user['avatarThumb']}",
        library_entries: Zorro::DB::AnimeProgress.count(_p_user: "_User$#{aozora_user['_id']}")
      }
    end

    # Note: only used at login time, not during display of conflicts
    #
    # @return [User] an already-imported Aozora User, matched by Facebook ID (or same ao_id)
    def imported_aozora_user
      # Only Facebook logins can trigger this because email logins are pre-merged
      return unless @ao_facebook_id
      @imported_aozora_user ||= User.where(ao_facebook_id: @ao_facebook_id).first
    end

    # @return [User] the user on Kitsu
    def kitsu_user
      @kitsu_user ||= if @facebook_id then User.where(facebook_id: @facebook_id).first
                      elsif @user then @user
                      elsif @email then User.by_email(@email).first
                      end
    end

    # @return [Hash] the user on Aozora
    def aozora_user
      # If the Kitsu user has an ao_imported, then we can't have a conflict
      return if kitsu_user&.ao_imported
      @aozora_user ||= if @ao_facebook_id
                         Zorro::DB::User.find('_auth_data_facebook.id' => @ao_facebook_id).first
                       elsif @user then Zorro::DB::User.find(_id: @user.ao_id).first
                       elsif @email then Zorro::DB::User.find(email: @email).first
                       end
    end
  end
end
