require 'rails_helper'

RSpec.describe MyAnimeListXmlGeneratorService do
  let(:user) { create(:user) }
  let(:anime1) { build(:anime) }
  let(:anime2) { build(:anime) }
  let(:manga1) { build(:manga) }
  let(:manga2) { build(:manga) }

  let!(:le1a) do
    create(:library_entry,
      media: anime1,
      user: user,
      started_at: Time.now,
      finished_at: Time.now,
      rating: 2)
  end
  let!(:le2a) { create(:library_entry, media: anime2, user: user) }
  let!(:le1m) do
    create(:library_entry,
      media: manga1,
      user: user,
      started_at: Time.now,
      finished_at: Time.now,
      rating: 2)
  end
  let!(:le2m) { create(:library_entry, media: manga2, user: user) }

  let(:builder) { Nokogiri::XML::Builder }

  context 'anime' do
    subject do
      described_class.new(user.library_entries.by_kind(:anime), 'anime')
    end

    before do
      allow(subject).to receive(:mal_external_site).and_return(1)
    end

    describe '#user_export_type' do
      it 'should return an xml object with 1' do
        output = builder.new do |xml|
          subject.user_export_type(xml)
        end
        mal_xml = '<user_export_type>1</user_export_type>'

        expect(output.to_xml).to include(mal_xml)
      end
    end

    describe '#progress' do
      it 'should return my_watched_episodes xml object' do
        output = builder.new do |xml|
          subject.progress(xml, le1a.progress)
        end

        expect(output.to_xml).to include(
          '<my_watched_episodes>0</my_watched_episodes>'
        )
      end
    end

    describe '#started_at' do
      context 'exists' do
        it 'should return my_start_date' do
          output = builder.new do |xml|
            subject.started_at(xml, le1a.started_at)
          end

          expect(output.to_xml).to include('<my_start_date>')
        end
      end
      context 'does not exist' do
        it 'should return nothing' do
          output = builder.new do |xml|
            subject.started_at(xml, le2a.started_at)
          end

          expect(output.to_xml).not_to include('<my_start_date>')
        end
      end
    end

    describe '#finished_at' do
      context 'exists' do
        it 'should return my_finish_date' do
          output = builder.new do |xml|
            subject.finished_at(xml, le1a.finished_at)
          end

          expect(output.to_xml).to include('<my_finish_date>')
        end
      end
      context 'does not exist' do
        it 'should return nothing' do
          output = builder.new do |xml|
            subject.finished_at(xml, le2a.finished_at)
          end

          expect(output.to_xml).not_to include('<my_finish_date>')
        end
      end
    end

    describe '#rating' do
      context 'exists' do
        it 'should return my_score' do
          output = builder.new do |xml|
            subject.rating(xml, le1a.rating)
          end

          expect(output.to_xml).to include('<my_score>2</my_score>')
        end
      end
      context 'does not exist' do
        it 'should return nothing' do
          output = builder.new do |xml|
            subject.rating(xml, le2a.rating)
          end

          expect(output.to_xml).not_to include('<my_score>')
        end
      end
    end

    describe '#status' do
      it 'should return my_status' do
        output = builder.new do |xml|
          subject.status(xml, le1a.status)
        end

        expect(output.to_xml).to include('<my_status>Plan to Watch</my_status>')
      end
    end

    describe '#reconsume_count' do
      it 'should return my_status' do
        output = builder.new do |xml|
          subject.reconsume_count(xml, le1a.reconsume_count)
        end

        expect(output.to_xml).to include(
          '<my_times_watched>0</my_times_watched>'
        )
      end
    end
  end

  context 'manga' do
    subject do
      described_class.new(user.library_entries.by_kind(:manga), 'manga')
    end

    before do
      allow(subject).to receive(:mal_external_site).and_return(1)
    end

    describe '#user_export_type' do
      it 'should return an xml object with 2' do
        output = builder.new do |xml|
          subject.user_export_type(xml)
        end
        mal_xml = '<user_export_type>2</user_export_type>'

        expect(output.to_xml).to include(mal_xml)
      end
    end

    describe '#progress' do
      it 'should return my_read_chapters xml object' do
        output = builder.new do |xml|
          subject.progress(xml, le1m.progress)
        end

        expect(output.to_xml).to include(
          '<my_read_chapters>0</my_read_chapters>'
        )
      end
    end

    describe '#started_at' do
      context 'exists' do
        it 'should return my_start_date' do
          output = builder.new do |xml|
            subject.started_at(xml, le1m.started_at)
          end

          expect(output.to_xml).to include('<my_start_date>')
        end
      end
      context 'does not exist' do
        it 'should return nothing' do
          output = builder.new do |xml|
            subject.started_at(xml, le2m.started_at)
          end

          expect(output.to_xml).not_to include('<my_start_date>')
        end
      end
    end

    describe '#finished_at' do
      context 'exists' do
        it 'should return my_finish_date' do
          output = builder.new do |xml|
            subject.finished_at(xml, le1m.finished_at)
          end

          expect(output.to_xml).to include('<my_finish_date>')
        end
      end
      context 'does not exist' do
        it 'should return nothing' do
          output = builder.new do |xml|
            subject.finished_at(xml, le2m.finished_at)
          end

          expect(output.to_xml).not_to include('<my_finish_date>')
        end
      end
    end

    describe '#rating' do
      context 'exists' do
        it 'should return my_score' do
          output = builder.new do |xml|
            subject.rating(xml, le1m.rating)
          end

          expect(output.to_xml).to include('<my_score>2</my_score>')
        end
      end
      context 'does not exist' do
        it 'should return nothing' do
          output = builder.new do |xml|
            subject.rating(xml, le2m.rating)
          end

          expect(output.to_xml).not_to include('<my_score>')
        end
      end
    end

    describe '#status' do
      it 'should return my_status' do
        output = builder.new do |xml|
          subject.status(xml, le1m.status)
        end

        expect(output.to_xml).to include('<my_status>Plan to Read</my_status>')
      end
    end

    describe '#reconsume_count' do
      it 'should return my_status' do
        output = builder.new do |xml|
          subject.reconsume_count(xml, le1m.reconsume_count)
        end

        expect(output.to_xml).to include(
          '<my_times_read>0</my_times_read>'
        )
      end
    end
  end
end
