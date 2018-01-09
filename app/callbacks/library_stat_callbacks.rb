# Hooks onto LibraryEntry and manages updating the stats
class LibraryStatCallbacks < Callbacks
  # @param klass [Class] the class to hook the callbacks for
  def self.hook(klass)
    klass.after_update(self)
    klass.after_create(self)
    klass.after_destroy(self)
  end

  def after_update
    perform_for :update
  end

  def after_create
    perform_for :create
  end

  def after_destroy
    perform_for :destroy
  end

  private

  def perform_for(action)
    case record.kind
    when :anime
      perform 'Stat::AnimeCategoryBreakdown', action
      perform 'Stat::AnimeAmountConsumed', action
      perform 'Stat::AnimeActivityHistory', action
    when :manga
      perform 'Stat::MangaCategoryBreakdown', action
      perform 'Stat::MangaAmountConsumed', action
      perform 'Stat::MangaActivityHistory', action
    end
  end

  def perform(worker, action)
    StatWorker.perform_async(worker, record.user, action, record)
  end
end
