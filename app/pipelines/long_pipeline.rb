LongPipeline = HTMLPipeline.new(
  convert_filter: HTMLFilters::InlineMarkdownFilter.new,
  node_filters: [
    HTMLFilters::KitsuMentionFilter.new,
    HTMLFilters::UnembedFilter.new
  ],
  default_context: {
    base_url: '/user/',
    link_attr: 'target="_blank" rel="nofollow" class="autolink"'
  }
)
