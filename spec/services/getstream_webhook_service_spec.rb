require 'rails_helper'

RSpec.describe GetstreamWebhookService do
  shared_examples_for 'correct action url' do |path|
    it 'should return the frontend url that refer to this action' do
      expect(GetstreamWebhookService.new(request).feed_url)
        .to eq("https://kitsu.io/#{path}")
    end
  end

  describe '#feed_url' do
    context 'when dealing with single activity' do
      context 'follow activity' do
        let(:request) do
          JSON.parse(fixture('getstream_webhook/new_feed_request.json')).first
        end

        it_should_behave_like 'correct action url', 'users/4'
      end

      context 'post activity' do
        let(:request) do
          JSON.parse(fixture('getstream_webhook/new_feed_request.json'))[1]
        end

        it_should_behave_like 'correct action url', 'posts/12'
      end

      context 'comment activity' do
        let(:request) do
          JSON.parse(fixture('getstream_webhook/new_feed_request.json'))[4]
        end

        it_should_behave_like 'correct action url', 'comments/9'
      end

      context 'post like activity' do
        let(:request) do
          JSON.parse(fixture('getstream_webhook/new_feed_request.json'))[2]
        end

        it_should_behave_like 'correct action url', 'posts/12'
      end

      context 'comment like activity' do
        let(:request) do
          JSON.parse(fixture('getstream_webhook/new_feed_request.json'))[3]
        end

        it_should_behave_like 'correct action url', 'comments/5'
      end

      context 'group invite activity' do
        let(:request) do
          JSON.parse(fixture('getstream_webhook/new_feed_request.json'))[7]
        end

        it_should_behave_like 'correct action url', 'group-invite/5'
      end
    end

    context 'when dealing with multiple activities' do
      let(:request) do
        JSON.parse(fixture('getstream_webhook/multi_activity_req.json')).first
      end

      it_should_behave_like 'correct action url', 'notifications'
    end
  end

  describe '#stringify_activity' do
    context 'follow, post, post_like and comment_like activity' do
      let(:request) do
        JSON.parse(fixture('getstream_webhook/new_feed_request.json'))
      end
      let!(:actor) { FactoryGirl.create(:user, id: 4) }
      let!(:target) { FactoryGirl.create(:user, id: 1) }

      it 'should localize follow activity string' do
        expect(GetstreamWebhookService.new(request.first)
          .stringify_activity[:en])
          .to eq("#{actor.name} followed you.")
      end

      it 'should localize post activity string' do
        expect(GetstreamWebhookService.new(request[1]).stringify_activity[:en])
          .to eq("#{actor.name} mentioned you in a post.")
      end

      it 'should localize post like activity string' do
        expect(GetstreamWebhookService.new(request[2]).stringify_activity[:en])
          .to eq("#{actor.name} liked your post.")
      end

      it 'should localize comment like activity string' do
        expect(GetstreamWebhookService.new(request[3]).stringify_activity[:en])
          .to eq("#{actor.name} liked your comment.")
      end

      it 'should localize group invite activity string' do
        expect(GetstreamWebhookService.new(request[7]).stringify_activity[:en])
          .to eq("#{actor.name} invited you to a group.")
      end
    end

    context 'comment activity' do
      let(:webhook_req) do
        JSON.parse(fixture('getstream_webhook/post_reply_request.json'))
      end
      let!(:actor) { FactoryGirl.create(:user, id: 4) }
      let!(:mentioned) { FactoryGirl.create(:user, id: 5) }
      let!(:followed) { FactoryGirl.create(:user, id: 6) }
      let!(:target) { FactoryGirl.create(:user, id: 1) }

      context 'when user is mentioned in comment' do
        let(:post_reply) { webhook_req[2] }
        let(:comment_reply) { webhook_req[3] }

        it 'should localize mentioned in a comment activity string' do
          expect(GetstreamWebhookService.new(post_reply)
            .stringify_activity[:en])
            .to eq("#{actor.name} mentioned you in a comment.")
        end

        it 'should localize mentioned in a comment activity string' do
          expect(GetstreamWebhookService.new(comment_reply)
            .stringify_activity[:en])
            .to eq("#{actor.name} mentioned you in a comment.")
        end
      end

      context 'when notification feed target and reply to user are same' do
        let(:post_reply) { webhook_req.first }
        let(:comment_reply) { webhook_req[1] }

        it 'should localize reply to post activity string' do
          expect(GetstreamWebhookService.new(post_reply)
            .stringify_activity[:en])
            .to eq("#{actor.name} replied to your post.")
        end

        it 'should localize reply to comment activity string' do
          expect(GetstreamWebhookService.new(comment_reply)
            .stringify_activity[:en])
            .to eq("#{actor.name} replied to your comment.")
        end
      end

      context 'when user are not mentioned and not being replied' do
        let(:comment) { webhook_req[4] }

        it 'should localize reply to post activity string' do
          service = GetstreamWebhookService.new(comment)
          expect(service).to receive(:followed_post_activity).with(actor.name)
          service.stringify_activity
        end
      end
    end

    context 'localization fallback' do
      let(:webhook_req) do
        JSON.parse(fixture('getstream_webhook/post_reply_request.json'))
      end
      let!(:actor) { FactoryGirl.create(:user, id: 4) }
      let!(:target) { FactoryGirl.create(:user, id: 1, language: 'fr') }
      let(:post_reply) { webhook_req.first }

      it 'should localize mentioned in a comment activity string' do
        expect(GetstreamWebhookService.new(post_reply)
          .stringify_activity[:fr])
          .to eq("#{actor.name} replied to your post.")
      end
    end
  end

  describe '#summarize_activities' do
    let(:webhook_req) do
      JSON.parse(fixture('getstream_webhook/multi_activity_req.json')).first
    end

    before do
      FactoryGirl.create(:user, id: 4)
      FactoryGirl.create(:user, id: 5)
    end

    it 'should return localized summary' do
      expect(GetstreamWebhookService.new(webhook_req)
        .send(:summarize_activities))
        .to eq('You got 2 follows, 1 post mention, 1 comment'\
          ', and 1 invite while you were away.')
    end
  end

  describe '#followed_post_activity' do
    let(:webhook_req) do
      JSON.parse(fixture('getstream_webhook/post_reply_request.json'))
    end

    context 'when post author not found' do
      let(:comment) { webhook_req[4] }

      it 'should stringify activity without author name' do
        expect(described_class.new(comment)
          .send(:followed_post_activity, 'Tony'))
          .to eq('Tony replied to a post.')
      end
    end

    context 'when actor is the post author' do
      let(:comment) { webhook_req[4] }
      let!(:actor) { FactoryGirl.create(:user, id: 4) }
      let!(:post) { FactoryGirl.create(:post, id: 11, user: actor) }

      it 'should stringify activity with actor name' do
        allow_any_instance_of(described_class).to receive(:actor_id)
          .and_return(4)
        expect(described_class.new(comment)
          .send(:followed_post_activity, actor.name))
          .to eq("#{actor.name} replied to their post.")
      end
    end

    context 'when notifying post author' do
      let(:comment) { webhook_req[4] }
      let!(:feed_user) { FactoryGirl.create(:user, id: 6) }

      before do
        FactoryGirl.create(:post, id: 11, user: feed_user)
        allow_any_instance_of(described_class).to receive(:feed_id)
          .and_return(6)
      end

      it 'should stringify activity with actor name' do
        expect(described_class.new(comment)
          .send(:followed_post_activity, 'Tony'))
          .to eq('Tony replied to your post.')
      end
    end

    context 'when notifying someone who followed the post' do
      let(:comment) { webhook_req[4] }
      let!(:author) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:post, id: 11, user: author)
      end

      it 'should stringify activity with actor and author name' do
        expect(described_class.new(comment)
          .send(:followed_post_activity, 'Tony'))
          .to eq("Tony replied to #{author.name}'s post.")
      end
    end
  end
end
