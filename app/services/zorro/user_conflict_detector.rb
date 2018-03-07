module Zorro
  # Service for detecting user conflicts, logging a user in, and displaying conflicts
  class UserConflictDetector
    AO_EPOCH = Date.new(2018, 2, 26)

    def initialize(email: nil, facebook_id: nil, ao_facebook_id: nil, user: nil)
      @email = email&.strip
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
        kitsu_user.update!(
          ao_id: aozora_user['_id'],
          ao_password: aozora_user['_hashed_password'],
          ao_facebook_id: aozora_user.dig('_auth_data_facebook', 'id'),
          status: :aozora
        )
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
      Zorro::Importer::UserImporter.new(aozora_user).run!(force: true)
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
        library_entries: library_count_for_ao(aozora_user['_id'])
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
      return @user if @user
      return @kitsu_user if @kitsu_user

      @kitsu_user = User.where(facebook_id: @facebook_id).first if @facebook_id
      @kitsu_user ||= User.by_email(@email).first
      @kitsu_user
    end

    # @return [Hash] the user on Aozora
    def aozora_user
      return unless ao_importable?

      return @aozora_user if @aozora_user
      return Zorro::DB::User.find(_id: @user.ao_id).first if @user

      options = []
      options << { '_auth_data_facebook.id' => @ao_facebook_id } if @ao_facebook_id
      options << { email: /\A\s*#{@email}\s*\z/i } if @email
      return nil if options.empty?

      @aozora_user = Zorro::DB::User.find('$or' => options).sort(_updated_at: -1).first
      @aozora_user = nil if @aozora_user && library_count_for_ao(@aozora_user['_id']) < 1
      @aozora_user
    end

    def library_count_for_ao(id)
      Zorro::DB::AnimeProgress.count(_p_user: "_User$#{id}")
    end

    def ao_importable?
      # No Conflict
      return true if kitsu_user.blank?
      # Post-conflict (chose Aozora)
      return false if kitsu_user.ao_imported
      # Post-conflict (chose Kitsu)
      return false if kitsu_user.ao_id && kitsu_user.registered?
      # If the Kitsu user isn't confirmed or predating Aozora, it's probably a thief!
      return false unless kitsu_user.confirmed || kitsu_user.created_at < AO_EPOCH
      # Otherwise we good
      true
    end
  end
end
