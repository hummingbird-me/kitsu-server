class Badge
  include DSL

  attr_reader :title, :description, :goal, :rank, :user

  def self.slug
    name.underscore.dasherize.sub('-badge', '')
  end

  def slug
    self.class.slug
  end

  def initialize(user)
    @user = user
    describe_context
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
    Bestowment.update_for(self)
  end

  private

  def describe_context
    @rank = 0
    next_goal = false
    ranks = self.class.ranks
    if ranks.blank?
      @title = self.class.title
      @description = self.class.description
      @goal = self.class.goal
    else
      ranks.each do |rank|
        state = self.class.const_get(rank)
        current_goal = get_goal_result(state.goal)
        if next_goal
          @goal = current_goal
          next_goal = false
        end
        next unless progress >= current_goal
        @rank = state.rank
        @title = state.title
        @description = state.description
        next_goal = true
      end
    end
    @rank
  end

  def get_goal_result(goal)
    if goal.is_a? Proc
      instance_eval(&goal)
    else
      goal
    end
  end
end
