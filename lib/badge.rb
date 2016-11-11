class Badge
  include DSL

  attr_reader :title, :description, :goal, :rank, :user

  def initialize(user)
    @user = user
    describe_context
    @bestowment = check_bestowment(@rank)
  end

  def check_bestowment(rank=nil)
    bestowment = Bestowment.where(
      badge_id: self.class,
      user: @user
    )
    bestowment = bestowment.where(rank: rank) if has_progress?
    bestowment.first
  end

  def bestowed(rank=nil)
    if has_progress?
      state = self.class.const_get("Rank#{rank}")
    else
      state = self
    end
    Bestowment.create(
      badge_id: self.class,
      rank: rank,
      user: @user,
      bestowed_at: DateTime.now,
      title: state.title,
      description: state.description
    )
  end

  def progress
    if self.class.progress.nil?
      nil
    else
      @progress ||= instance_eval(&self.class.progress)
    end
  end

  def earned?
    return false unless @goal
    if progress.nil?
      instance_eval(&@goal)
    else
      progress > @goal
    end
  end

  def run
    #bestowed badge if all ranks was earned
    bestowed(@rank) if earned? && @bestowment.nil?
    #bestowed previous rank if it not earned
    if (@rank - 1) > 0 && has_progress? && check_bestowment(@rank - 1).nil?
      bestowed(@rank - 1)
    end
  end

  def has_progress?
    self.class.ranks.present?
  end

  private

  def describe_context
    @rank = 0
    stop = false
    ranks = self.class.ranks
    if ranks.blank?
      @title = self.class.title
      @description = self.class.description
      @goal = self.class.goal
    else
      ranks.each do |rank|
        break if stop
        state = self.class.const_get(rank)
        current_goal = get_goal_result(state.goal)
        next unless progress < current_goal
        @rank = state.rank
        @title = state.title
        @description = state.description
        @goal = current_goal
        stop = true
      end
    end
  end

  def get_goal_result(goal)
    if goal.is_a? Proc
      instance_eval(&goal)
    else
      goal
    end
  end
end
