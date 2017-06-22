class Badge
  include DSL

  attr_reader :title, :description, :rank, :user, :goal

  def initialize(user)
    @user = user
    describe_context
    @bestowment = check_bestowment
  end

  def check_bestowment
    Bestowment.where(
      badge_id: self.class,
      user: @user
    ).first
  end

  def bestowed
    Bestowment.create(
      badge_id: self.class,
      rank: @rank,
      user: @user,
      bestowed_at: DateTime.now,
      title: @title,
      description: @description
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
      @goal
    else
      progress >= @goal
    end
  end

  def run
    bestowed if earned? && @bestowment.nil?
  end

  private

  def describe_context
    @rank = self.class.rank || 0
    @title = self.class.title
    @description = self.class.description
    @goal = get_goal_result(self.class.goal)
  end

  def get_goal_result(goal)
    if goal.is_a? Proc
      instance_eval(&goal)
    else
      goal
    end
  end
end
