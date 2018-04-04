LongPipeline = HTML::Pipeline.new [
  HTML::Pipeline::InlineMarkdownFilter,
  HTML::Pipeline::SanitizationFilter,
  HTML::Pipeline::KitsuMentionFilter,
  HTML::Pipeline::AutolinkFilter,
  HTML::Pipeline::OneboxFilter,
  HTML::Pipeline::EmbedFilter
], base_url: '/user/',
   link_attr: 'target="_blank" rel="nofollow" class="autolink"'
