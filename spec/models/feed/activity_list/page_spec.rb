require 'rails_helper'

RSpec.describe Feed::ActivityList::Page do
  subject { Feed::ActivityList::Page.new(data.as_json, opts) }
  let(:user) { create(:user) }
  let(:opts) { { feed: feed } }

  context 'on a flat feed' do
    let(:feed) { OpenStruct.new(:aggregated? => false) }
    let(:data) do
      [
        { nsfw: true, actor: user.stream_id },
        { nsfw: false, actor: user.stream_id }
      ]
    end

    context 'with a fast-path select' do
      it "should remove any activities which don't match the select" do
        opts[:fast_selects] = [->(act) { act['nsfw'] == false }]
        expect(subject.to_a.size).to eq(1)
      end

      it 'should run prior to enrichment' do
        opts[:includes] = %i[actor]
        opts[:fast_selects] = [->(act) { expect(act['actor']).to be_a(String) }]
        subject.to_a
      end
    end

    context 'with a slow-path select' do
      it 'should be run after enrichment' do
        opts[:includes] = %i[actor]
        opts[:slow_selects] = [->(act) { expect(act['actor']).to be_a(User) }]
        subject.to_a
      end
    end

    context 'with an inclusion' do
      let(:media) { create(:anime) }
      let(:data) do
        [
          { media: media.stream_id }
        ]
      end

      it 'should enrich the key specified' do
        opts[:includes] = %i[media]
        expect(subject.to_a.first.media).to be_an(Anime)
      end
    end

    context 'with a map' do
      it 'should modify the activities' do
        opts[:maps] = [->(act) { act.merge('foo' => 'hello') }]
      end

      it 'should run after enrichment' do
        opts[:includes] = %i[actor]
        opts[:maps] = [->(act) { expect(act['actor']).to be_a(User); act }]
        subject.to_a
      end
    end

    describe '#to_a' do
      it 'should return an array of Feed::Activity objects' do
        expect(subject.to_a).to all(be_a(Feed::Activity))
      end
    end
  end

  context 'on an aggregated feed' do
    let(:feed) { OpenStruct.new(:aggregated? => true) }
    let(:data) do
      [
        {
          activities: [
            { nsfw: true },
            { nsfw: false }
          ]
        }
      ]
    end

    context 'with a select' do
      it 'should run on each activity' do
        opts[:fast_selects] = [->(act) do
          expect(act).to include('nsfw')
          true
        end]
        subject.to_a
      end

      it 'should remove empty activity groups' do
        opts[:fast_selects] = [->(_) { false }]
        expect(subject.to_a.size).to eq(0)
      end
    end

    context 'with a map' do
      it 'should run on each activity' do
        opts[:maps] = [->(act) do
          expect(act).to include('nsfw')
          act
        end]
        subject.to_a
      end
    end

    context 'for activity groups in STRIPPED_VERBS' do
      let(:data) do
        [
          {
            verb: 'post',
            activities: [{}, {}, {}, {}]
          }
        ]
      end

      it 'should strip down the activities list to just one' do
        expect(subject.to_a.first['activities'].size).to eq(1)
      end
    end
  end
end
