class GetstreamWebhookParser
  def initialize(data)
    @data = data
  end

  def each
    @data.each do |feed|
      feed['new'].each do |activity|
        yield feed['feed'], :new, activity
      end
      feed['deleted'].each do |activity|
        yield feed['feed'], :deleted, activity
      end
    end
  end
end
