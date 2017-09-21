# Handy dandy mixin for providing a progress bar shortcut with our default format!
module WithProgressBar
  extend ActiveSupport::Concern

  class_methods do
    # Shortcut to generating a new progress bar object
    #
    # @param title [String] the label to be displayed for the progress bar
    # @param count [Integer] the number of ticks this progress bar has to completion
    # @return [ProgressBar] the progress bar object
    def progress_bar(title, count)
      ProgressBar.create(
        title: title,
        total: count,
        output: STDERR,
        format: '%a (%p%%) |%B| %E %t'
      )
    end
  end

  delegate :progress_bar, to: :class
end
