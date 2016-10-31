class Badge
  include DSL

  def self.slug
    self.name.underscore.dasherize.sub('-badge', '')
  end

  def slug
    self.class.slug
  end

  def initialize(user)
    @user = user
  end

  attr_reader :user

  def progress
    return 0 unless show_progress?

    context.instance_eval(&self.class.progress)
  end

  def goal
    self.class.goal
  end

  def earned?
    return false unless goal

    if show_progress?
      progress >= goal
    else
      context.instance_eval(goal)
    end
  end

  def run
    if has_progress?
      Bestowment.update_for(self) if progress > 0 && lowest_unachieved_in_group?
    else
      Bestowment.earn(self) if earned?
    end
  end

  private

  def context
    OpenStruct.new(user: @user)
  end

  def show_progress?
    !goal.respond_to?(:call)
  end
end
