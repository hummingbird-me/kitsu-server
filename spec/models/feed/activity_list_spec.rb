require 'rails_helper'

RSpec.describe Feed::ActivityList, type: :model do
  let(:feed_class) { Class.new(Feed) { feed_name 'timeline' } }
  let(:feed) { feed_class.new('1') }
  let(:list) { Feed::ActivityList.new(feed) }
  subject { list }

  describe '#page' do
    context 'with a page number' do
      subject { list.page(1) }
      it 'should set the page_number' do
        expect(subject.page_number).to eq(1)
      end
    end
    context 'with an id_lt' do
      subject { list.page(id_lt: '12345') }
      it 'should set the id_lt on the query' do
        expect(subject.data).to have_key(:id_lt)
      end
    end
  end

  describe '#per' do
    subject { list.per(10) }
    it 'should set the page_size attribute' do
      expect(subject.page_size).to eq(10)
    end
  end

  describe 'combining #per and #page' do
    subject { list.per(10).page(5) }
    it 'should set the offset in the query' do
      expect(subject.data[:offset]).to eq(40)
    end
    it 'should set the limit in the query' do
      expect(subject.data[:limit]).to eq(10)
    end
  end

  describe '#limit' do
    subject { list.limit(20) }
    it 'should set the limit in the query' do
      expect(subject.data[:limit]).to eq(20)
    end
  end

  describe '#offset' do
    subject { list.offset(20) }
    it 'should set the offset in the query' do
      expect(subject.data[:offset]).to eq(20)
    end
  end

  describe '#ranking' do
    subject { list.ranking('cool_ranking') }
    it 'should set the ranking in the query' do
      expect(subject.data[:ranking]).to eq('cool_ranking')
    end
  end

  describe '#new' do
    it 'should return an Activity with the feed preloaded' do
      expect(subject.new).to be_a(Feed::Activity)
    end
  end

  describe '#add' do
    let(:activity) { Feed::Activity.new(subject) }
    it 'should tell Stream to add the activity by JSON' do
      expect(subject.feed).to receive(:add_activity)
        .with(Hash).once.and_return({})
      subject.add(activity)
    end
  end

  describe '#update' do
    let(:activity) { Feed::Activity.new(subject) }
    before { activity }
    it 'should tell Stream to update the activity by JSON' do
      client = double('Stream::Client')
      allow(Feed::StreamFeed).to receive(:client).and_return(client)
      expect(client).to receive(:update_activity).with(Hash).once
      subject.update(activity)
    end
  end

  describe '#destroy' do
    context 'with string foreign_id' do
      let(:activity) { Feed::Activity.new(subject, foreign_id: 'id') }
      it 'should tell Stream to remove the activity by ID' do
        expect(subject.feed.stream_feed).to receive(:remove_activity)
          .with('id', foreign_id: true).once
        subject.destroy(activity)
      end
    end

    context 'with object foreign_id' do
      let(:object) { OpenStruct.new(stream_id: 'id') }
      let(:activity) { Feed::Activity.new(subject, foreign_id: object) }
      it 'should tell Stream to remove the activity by the #stream_id' do
        expect(subject.feed.stream_feed).to receive(:remove_activity)
          .with('id', foreign_id: true).once
        subject.destroy(activity)
      end
    end

    context 'with uuid' do
      it 'should tell Stream to remove the activity' do
        activity = list.new(
          actor: 'User:1',
          object: 'Post:1',
          verb: 'test'
        ).create
        expect(subject.feed.stream_feed).to receive(:remove_activity)
          .with(activity.id)
        subject.destroy(activity.id, uuid: true)
      end
    end
  end

  describe '#find' do
    let(:attrs) do
      {
        'id' => 'activity_id',
        'verb' => 'test'
      }
    end
    let(:act) { subject.new(attrs) }

    before do
      expect(subject.send(:stream_feed)).to receive(:get)
        .with(include(id_lte: attrs['id'], limit: 1))
        .and_return('results' => [attrs])
    end

    it 'should return a single Activity' do
      subject.find(attrs['id'])
    end
  end

  describe '#to_a' do
    subject { list.limit(50) }

    it 'should get the activities using the query and read the results' do
      expect(subject.send(:stream_feed)).to receive(:get).at_least(:once)
        .and_return('results' => [])
      expect(subject.to_a).to eq([])
    end

    context 'for an aggregated feed' do
      let(:feed_class) do
        Class.new(Feed) do
          feed_name 'timeline'
          feed_type :aggregated
        end
      end
      subject { Feed::ActivityList.new(feed_class.new('1')) }

      it 'should return an Array of ActivityGroup instances' do
        expect(subject.send(:stream_feed)).to receive(:get).at_least(:once)
          .and_return(
            'results' => [
              {
                'activities' => [{}]
              }, {
                'activities' => [{}]
              }
            ]
          )
        expect(subject.to_a).to all(be_a(Feed::ActivityGroup))
      end

      context 'for activities around post verbs' do
        let(:activity_1) do
          {
            'target' => 'Post:1',
            'object' => 'Comment:1',
            'actor' => 'User:1',
            'verb' => 'comment'
          }
        end

        let(:activity_2) do
          {
            'target' => 'Post:1',
            'object' => 'Comment:2',
            'actor' => 'User:1',
            'verb' => 'comment'
          }
        end

        it 'should return the first activity of each group' do
          allow(subject.send(:stream_feed)).to receive(:get)
            .and_return(
              'results' => [
                {
                  'activities' => [activity_1, activity_2],
                  'verb' => 'comment'
                },
                {
                  'activities' => [activity_1, activity_2],
                  'verb' => 'post'
                },
                {
                  'activities' => [activity_1, activity_2],
                  'verb' => 'follow'
                },
                {
                  'activities' => [activity_1, activity_2],
                  'verb' => 'review'
                }
              ]
            )
          expect(subject.to_a)
            .to all(have_attributes(
                      activities: [an_instance_of(Feed::Activity)]
            ))
        end
      end

      context 'for activities around media verbs' do
        let(:activity_1) do
          {
            'media' => 'Anime:1',
            'object' => 'LibraryEntry:2',
            'actor' => 'User:1',
            'verb' => 'rated'
          }
        end

        let(:activity_2) do
          {
            'media' => 'Anime:1',
            'object' => 'LibraryEntry:1',
            'actor' => 'User:1',
            'verb' => 'rated'
          }
        end

        it 'should return all the activities of each group' do
          allow(subject.send(:stream_feed)).to receive(:get)
            .and_return(
              'results' => [
                {
                  'activities' => [activity_1, activity_2],
                  'verb' => 'rated'
                },
                {
                  'activities' => [activity_1, activity_2],
                  'verb' => 'updated'
                },
                {
                  'activities' => [activity_1, activity_2],
                  'verb' => 'progressed'
                }
              ]
            )
          expect(subject.to_a)
            .to all(have_attributes(
                      activities: [an_instance_of(Feed::Activity),
                                   an_instance_of(Feed::Activity)]
            ))
        end
      end
    end

    context 'for a flat feed' do
      let(:feed_class) do
        Class.new(Feed) do
          feed_name 'timeline'
          feed_type :flat
        end
      end
      subject { Feed::ActivityList.new(feed_class.new('1')) }

      it 'should return an Array of Activity instances' do
        expect(subject.send(:stream_feed)).to receive(:get).at_least(:once)
          .and_return('results' => [{}, {}])
        expect(subject.to_a).to all(be_a(Feed::Activity))
      end
    end
  end
end
