require_dependency 'html/pipeline/kramdown_filter'

RulesPipeline = HTML::Pipeline.new [
  HTML::Pipeline::KramdownFilter,
  HTML::Pipeline::SanitizationFilter,
  HTML::Pipeline::KitsuMentionFilter,
  HTML::Pipeline::AutolinkFilter
], base_url: '/user/',
   link_attr: 'target="_blank" rel="nofollow" class="autolink"'
