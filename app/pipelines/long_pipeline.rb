LongPipeline = HTML::Pipeline.new([
  HTMLFilters::InlineMarkdownFilter,
  HTML::Pipeline::SanitizationFilter,
  HTMLFilters::KitsuMentionFilter,
  HTML::Pipeline::AutolinkFilter,
  HTMLFilters::UnembedFilter
],
  base_url: '/user/',
  link_attr: 'target="_blank" rel="nofollow" class="autolink"')
