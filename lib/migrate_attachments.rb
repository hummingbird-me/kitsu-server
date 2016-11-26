class MigrateAttachments
  BUCKET = 'kitsu-media'.freeze

  SOURCE = ':class/:attachment/:id_partition/:style/:filename'.freeze
  TARGET = ':class/:attachment/:id/:style.:content_type_extension'.freeze

  attr_reader :client, :scope, :attachment

  def initialize(scope, attachment)
    @client = Aws::S3::Client.new
    @scope = scope
    @attachment = attachment
  end

  def run
    each_item do |item|
      move item.public_send(attachment)
    end
  end

  private

  def move(attachment)
    return if attachment.blank?
    old = Paperclip::Interpolations.interpolate(SOURCE, attachment, 'original')
    new = Paperclip::Interpolations.interpolate(TARGET, attachment, 'original')

    client.copy_object(bucket: BUCKET, copy_source: "#{BUCKET}/#{old}",
                       key: new) rescue return
    client.delete_object(bucket: BUCKET, key: old)
  end

  def each_item(&block)
    items = scope.find_each.lazy
    bar = progress_bar("#{scope.table_name}/#{attachment}", scope.count(:all))
    items.map(&block).map { |i| bar.increment; i }.reject(&:nil?)
  end

  def progress_bar(title, count)
    ProgressBar.create(
      title: title,
      total: count,
      output: STDERR,
      format: '%a (%p%%) |%B| %E %t'
    )
  end
end
