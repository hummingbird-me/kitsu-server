class MediaReactionVote < ActiveRecord::Base
  belongs_to :media_reaction, required: true, counter_cache: :up_votes_count
  belongs_to :user, required: true
end
