RulesPipeline = HTMLPipeline.new(
  convert_filter: HTMLFilters::KramdownFilter.new,
  node_filters: [
    HTMLFilters::KitsuMentionFilter.new
  ],
  default_context: {
    base_url: '/user/',
    link_attr: 'target="_blank" rel="nofollow" class="autolink"'
  }
)
