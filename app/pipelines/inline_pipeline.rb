require_dependency 'html/pipeline/inline_markdown_filter'

InlinePipeline = HTML::Pipeline.new [
  InlineMarkdownFilter,
  SanitizationFilter
]
