FakeStream.fake!
FakeStream.configure do
  feed :user, :flat
  feed :user_aggr, :aggregated
  feed :media, :flat
  feed :media_aggr, :aggregated
  feed :timeline, :aggregated
  feed :notifications, :notification
end
