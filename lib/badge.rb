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

  def current_rank
    current_rank = 0
    self.class::RANKS.each do |key, value|
      if progress > value[:bestow_when]
        current_rank = key
      end
    end
    current_rank
  end

  def current_goal
    rank = current_rank + 1
    self.class::RANKS[rank][:bestow_when]
  end

  def current_title_description
    rank = self.class::RANKS[current_rank]
    [rank[:title], rank[:description]]
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
    #if show_progress?
      Bestowment.update_for(self) # if progress > 0 && lowest_unachieved_in_group?
    #else
      #Bestowment.earn(self) if earned?
    #end
  end

  private

  def context
    OpenStruct.new(user: @user)
  end

  def show_progress?
    !goal.respond_to?(:call)
  end

  def has_progress?
    true
  end
end
