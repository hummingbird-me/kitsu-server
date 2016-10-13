require_dependency 'html/pipeline/inline_markdown_filter'

InlinePipeline = HTML::Pipeline.new [
  HTML::Pipeline::InlineMarkdownFilter,
  HTML::Pipeline::SanitizationFilter
]
