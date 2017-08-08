require_dependency 'html/pipeline/inline_markdown_filter'
require_dependency 'html/pipeline/kitsu_mention_filter'
require_dependency 'html/pipeline/onebox_filter'
require_dependency 'html/pipeline/embed_filter'

LongPipeline = HTML::Pipeline.new [
  HTML::Pipeline::InlineMarkdownFilter,
  HTML::Pipeline::SanitizationFilter,
  HTML::Pipeline::KitsuMentionFilter,
  HTML::Pipeline::AutolinkFilter,
  HTML::Pipeline::OneboxFilter,
  HTML::Pipeline::EmbedFilter
], base_url: '/user/',
   link_attr: 'target="_blank" rel="nofollow" class="autolink"'
