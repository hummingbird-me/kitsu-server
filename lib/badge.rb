class Badge
  include DSL

  attr_reader :title, :description, :goal, :rank, :user

  def self.slug
    self.name.underscore.dasherize.sub('-badge', '')
  end

  def slug
    self.class.slug
  end

  def initialize(user)
    @user = user
    get_context
  end

  def progress
    @progress ||= instance_eval(&self.class.progress)
  end

  def earned?
    return false unless @goal
    progress > @goal
  end

  def run
    Bestowment.update_for(self)
  end

  private

  def get_context
    @rank = 0
    next_goal = false
    self.class.ranks.each do |rank|
      state = self.class.const_get(rank)
      current_goal = get_goal_result(state.goal)
      if next_goal
        @goal = current_goal
        next_goal = false
      end
      if progress >= current_goal
        @rank = state.rank
        @title = state.title
        @description = state.description
        next_goal = true
      end
    end
    @rank
  end

  def get_goal
    state = self.class.const_get("Rank#{rank}")
    @goal = get_goal_result(state.goal)
  end

  def get_goal_result(goal)
    if goal.is_a? Proc
      instance_eval(&goal)
    else
      goal
    end
  end
end
