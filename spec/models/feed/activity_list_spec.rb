require 'rails_helper'

RSpec.describe Feed::ActivityList, type: :model do
  class TestFeed < Feed; end

  let(:list) { described_class.new(feed) }
  let(:feed) { instance_spy(TestFeed) }
  let(:client) { instance_spy(Stream::Client) }

  before do
    allow(feed).to receive(:activities).and_return(list)
    allow(feed).to receive(:client).and_return(client)
  end

  describe '#page' do
    context 'with an id_lt' do
      let(:list) { super().page(id_lt: '12345') }

      it 'sets the id_lt on the query' do
        expect(list.data).to have_key(:id_lt)
      end
    end
  end

  describe '#per' do
    let(:list) { super().per(10) }

    it 'sets the limit in the query' do
      expect(list.data[:limit]).to eq(10)
    end
  end

  describe '#limit' do
    let(:list) { super().limit(20) }

    it 'sets the limit in the query' do
      expect(list.data[:limit]).to eq(20)
    end
  end

  describe '#offset' do
    let(:list) { super().offset(20) }

    it 'sets the offset in the query' do
      expect(list.data[:offset]).to eq(20)
    end
  end

  describe '#ranking' do
    let(:list) { super().ranking('cool_ranking') }

    it 'sets the ranking in the query' do
      expect(list.data[:ranking]).to eq('cool_ranking')
    end
  end

  describe '#new' do
    it 'returns an Activity with the feed preloaded' do
      expect(list.new).to be_a(Feed::Activity)
    end
  end

  describe '#add' do
    let(:activity) { Feed::Activity.new(list) }

    it 'tells Stream to add the activity by JSON' do
      allow(feed).to receive(:add_activity).once.and_return({})
      list.add(activity)
      expect(feed).to have_received(:add_activity).with(Hash)
    end
  end

  describe '#update' do
    let!(:activity) { Feed::Activity.new(list) }

    it 'tells Stream to update the activity by JSON' do
      list.update(activity)
      expect(client).to have_received(:update_activity).with(Hash).once
    end
  end

  describe '#destroy' do
    context 'with string foreign_id' do
      let(:activity) { Feed::Activity.new(list, foreign_id: 'id') }

      it 'tells Stream to remove the activity by ID' do
        list.destroy(activity)
        expect(feed).to have_received(:remove_activity).with('id', foreign_id: true).once
      end
    end

    context 'with object foreign_id' do
      let(:activity) { Feed::Activity.new(list, foreign_id: 'Anime:17') }

      it 'tells Stream to remove the activity' do
        list.destroy(activity)
        expect(feed).to have_received(:remove_activity).with('Anime:17', foreign_id: true).once
      end
    end

    context 'with uuid' do
      it 'tells Stream to remove the activity' do
        activity = list.new(
          actor: 'User:1',
          object: 'Post:1',
          verb: 'test'
        ).create
        list.destroy(activity.id, uuid: true)
        expect(feed).to have_received(:remove_activity).with(activity.id)
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
    let(:act) { list.new(attrs) }

    before do
      allow(feed.client).to receive(:get_activities)
        .with(ids: [attrs['id']])
        .and_return('results' => [attrs])
    end

    it 'returns a single Activity' do
      expect(list.find(attrs['id'])).to be_a(Feed::Activity)
    end
  end

  describe '#to_a' do
    let(:list) { super().limit(50) }

    it 'gets the activities using the query and read the results' do
      allow(feed).to receive(:get).at_least(:once).and_return('results' => [])
      expect(list.to_a).to eq([])
    end

    context 'for an aggregated feed' do
      it 'returns an Array of ActivityGroup instances' do
        allow(feed).to receive(:get).at_least(:once).and_return(
          'results' => [
            {
              'activities' => [{}]
            }, {
              'activities' => [{}]
            }
          ]
        )
        expect(list.to_a).to all(be_a(Feed::ActivityGroup))
      end

      context 'for activities around post verbs' do
        let(:activity1) do
          {
            'target' => 'Post:1',
            'object' => 'Comment:1',
            'actor' => 'User:1',
            'verb' => 'comment'
          }
        end

        let(:activity2) do
          {
            'target' => 'Post:1',
            'object' => 'Comment:2',
            'actor' => 'User:1',
            'verb' => 'comment'
          }
        end

        it 'returns the first activity of each group' do
          allow(feed).to receive(:get)
            .and_return(
              'results' => [
                {
                  'activities' => [activity1, activity2],
                  'verb' => 'comment'
                },
                {
                  'activities' => [activity1, activity2],
                  'verb' => 'post'
                },
                {
                  'activities' => [activity1, activity2],
                  'verb' => 'follow'
                },
                {
                  'activities' => [activity1, activity2],
                  'verb' => 'review'
                }
              ]
            )
          expect(list.to_a)
            .to all(have_attributes(activities: [an_instance_of(Feed::Activity)]))
        end
      end

      context 'for activities around media verbs' do
        let(:activity1) do
          {
            'media' => 'Anime:1',
            'object' => 'LibraryEntry:2',
            'actor' => 'User:1',
            'verb' => 'rated'
          }
        end

        let(:activity2) do
          {
            'media' => 'Anime:1',
            'object' => 'LibraryEntry:1',
            'actor' => 'User:1',
            'verb' => 'rated'
          }
        end

        it 'returns all the activities of each group' do
          allow(feed).to receive(:get)
            .and_return(
              'results' => [
                {
                  'activities' => [activity1, activity2],
                  'verb' => 'rated'
                },
                {
                  'activities' => [activity1, activity2],
                  'verb' => 'updated'
                },
                {
                  'activities' => [activity1, activity2],
                  'verb' => 'progressed'
                }
              ]
            )
          expect(list.to_a)
            .to all(have_attributes(
                      activities: [an_instance_of(Feed::Activity),
                                   an_instance_of(Feed::Activity)]
                    ))
        end
      end
    end

    context 'for a flat feed' do
      it 'returns an Array of Activity instances' do
        allow(feed).to receive(:get).at_least(:once).and_return('results' => [{}, {}])
        expect(list.to_a).to all(be_a(Feed::Activity))
      end
    end
  end
end
