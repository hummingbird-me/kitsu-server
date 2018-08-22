module StreamDump
  module_function

  def run(out:)
    PostsDump.run(out: out)
    AutoFollowsDump.run(out: out)
    FollowsDump.run(out: out)
    ReleaseFollowsDump.run(out: out)
  end

  def each_id(scope, title, pluck: %i[id], &block)
    items = scope.pluck(*pluck).each.lazy
    bar = progress_bar(title, scope.count(:all))
    # HACK: Normally we'd use #each because we don't want to modify the values,
    # but we need to stay lazy, and Enumerator::Lazy#each will collapse the
    # laziness.
    items.map(&block).map { |i|
      bar.increment
      i
    }.reject(&:nil?)
  end

  def progress_bar(title, count)
    ProgressBar.create(
      title: title,
      total: count,
      output: STDERR,
      format: '%a (%p%%) |%B| %E %t'
    )
  end
end
