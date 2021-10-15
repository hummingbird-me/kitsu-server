RulesPipeline = HTML::Pipeline.new [
  HTMLFilters::KramdownFilter,
  HTML::Pipeline::SanitizationFilter,
  HTMLFilters::KitsuMentionFilter,
  HTML::Pipeline::AutolinkFilter
], base_url: '/user/',
   link_attr: 'target="_blank" rel="nofollow" class="autolink"'
