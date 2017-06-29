# Handles creating and updating bestowments for a (badge, user) pair.
class Badge
  class BestowmentService
    attr_reader :badge, :user

    # @param [Class<Badge>] the badge to handle bestowments for
    # @param [User] the user to bestow this badge upon
    def initialize(badge, user)
      @badge = badge
      @user = user
    end

    # Actually creates/updates Bestowments for the badge
    def run!
      tracked_ranks.each do |(rank, progress)|
        bestowment = bestowment_for(rank).first_or_initialize
        # Ratcheting - progress can only increase, never decrease.
        bestowment.progress = [bestowment.progres, progress].max
        bestowment.save!
      end
    end

    private

    # @param [Integer] rank the rank to find a bestowment for
    # @return [ActiveRecord::Relation<Bestowment>] the bestowment for this rank,
    #                                              if one exists
    def bestowment_for(rank)
      bestowments.for_rank(rank)
    end

    # @return [ActiveRecord::Relation<Bestowment>] the existing bestowments for
    #                                              the badge
    def bestowments
      Badge::Bestowment.for_badge(badge).for_user(user)
    end

    # @return [Array<Array<Integer, Float>>] the progress for each rank of the
    #                                        badge
    def ranks
      @ranks ||= badge.progress_for(user)
    end

    # @return [Array<Array<Integer, Float>>] the progress, filtered to ranks we
    #                                        want to track progress on
    def tracked_ranks
      # Basically {Enumerator#take_while} except the returned value includes the
      # first one which fails (so we can show progress)
      ranks.each_with_object([]) do |(rank, progress), acc|
        acc << [rank, progress]
        break acc if progress < 1.0
      end
    end
  end
end
