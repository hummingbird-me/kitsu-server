require_dependency 'html/pipeline/inline_markdown_filter'

InlinePipeline = HTML::Pipeline.new [
  HTML::Pipeline::InlineMarkdownFilter,
  HTML::Pipeline::SanitizationFilter,
  HTML::Pipeline::KitsuMentionFilter,
  HTML::Pipeline::AutolinkFilter,
  HTML::Pipeline::UnembedFilter
], base_url: '/user/', link_attr: 'target="_blank" rel="nofollow"'
