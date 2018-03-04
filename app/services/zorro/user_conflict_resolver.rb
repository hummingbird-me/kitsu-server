module Zorro
  # Service for handling the resolution of an account conflict, allowing a user to choose which
  # account (Aozora or Kitsu) they want to keep, merging UGC between them, and then taking the
  # profile and library data from the chosen one.
  class UserConflictResolver
    delegate :ao_id, to: :@user
    delegate :status, to: :@user

    def initialize(user)
      @user ||= user
    end

    def conflict?
      ao_id.present?
    end

    def merge_onto(chosen)
      return @user unless conflict?

      # Merging an already-imported Aozora User is more complicated, so we delegate that.
      return merge_imported_aozora_user(chosen) if imported_aozora_user

      # Merge an unimported Aozora User
      case chosen
      when :aozora
        # Merge the Aozora data onto this profile
        Zorro::Importer::UserImporter.new(aozora_user).run!(
          force: true,
          target_user: @user
        )
      when :kitsu
        # Just do nothing, pretty much.  Their UGC will get imported by the bulk stuff
        @user.update!(status: :registered)
        Zorro::FollowImportWorker.perform_async(@user.id)
        @user
      end
    end

    private

    # During bulk import, we can't match Aozora Facebook ID to Kitsu Facebook ID, so we may end up
    # with two Users tied to the same Facebook account from both Kitsu and Aozora.
    def merge_imported_aozora_user(chosen)
      # Always reparent their existing UGC
      # TODO: how to handle this in Stream????
      UserContentReparentWorker.perform_async(imported_aozora_user.id, @user.id)
      # Merge their profile data in if they have chosen aozora
      if chosen == :aozora
        Zorro::Importer::UserImporter.new(aozora_user).run!(
          force: true,
          target_user: @user
        )
      end
      # Delete the imported profile
      # TODO: make sure this runs after UserContentReparentWorker
      DestructionWorker.perform_async('User', imported_aozora_user.id)
    end

    def aozora_user
      Zorro::DB::User.find(_id: ao_id).first
    end

    def imported_aozora_user
      # Find a User with the same ao_id who *isn't* this one.
      User.where(ao_id: ao_id).where.not(id: @user.id).first
    end
  end
end
