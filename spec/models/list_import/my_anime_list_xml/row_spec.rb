require 'rails_helper'

RSpec.describe ListImport::MyAnimeListXML::Row do
  def create_mapping(media)
    raise 'Media must be saved' unless media.persisted?
    prefix = media.class.name.underscore
    fake_id = rand(1..50_000)
    create(:mapping,
      item: media,
      external_site: "myanimelist/#{prefix}",
      external_id: fake_id)
  end

  context 'with an invalid node name' do
    it 'raises an error' do
      expect {
        xml = Nokogiri::XML.fragment('<test></test>').at_css('test')
        described_class.new(xml)
      }.to raise_error(/invalid type/i)
    end
  end

  context 'with anime' do
    let(:anime) { create(:anime, episode_count: rand(6..50)) }

    def wrap_row(xml)
      Nokogiri::XML.fragment("<anime>#{xml}</anime>").at_css('anime')
    end

    describe '#type' do
      it 'returns Anime class' do
        row = described_class.new(wrap_row(''))
        expect(row.type).to eq(Anime)
      end
    end

    describe '#media' do
      context 'with a specific Mapping' do
        let(:mapping) { create_mapping(anime) }
        let(:xml) { wrap_row <<~XML }
          <series_animedb_id>
            #{mapping.external_id.split('/').last}
          </series_animedb_id>
          <series_title>#{anime.canonical_title}</series_title>
          <series_type>#{anime.subtype}</series_type>
          <series_episodes>#{anime.episode_count}</series_episodes>
        XML

        it 'returns the Anime instance from the Mapping' do
          row = described_class.new(xml)
          allow(Mapping).to receive(:lookup)
            .with('myanimelist/anime', mapping.external_id.to_i)
            .and_return(anime)
          expect(row.media).to eq(anime)
        end
      end

      context 'without a specific Mapping' do
        let(:xml) { wrap_row <<~XML }
          <series_animedb_id>#{rand(1..50_000)}</series_animedb_id>
          <series_title>#{anime.canonical_title}</series_title>
          <series_type>#{anime.subtype}</series_type>
          <series_episodes>#{anime.episode_count}</series_episodes>
        XML

        it 'guesses the Anime instance using Mapping.guess' do
          row = described_class.new(xml)
          allow(Mapping).to receive(:guess).and_return(anime)
          expect(row.media).to eq(anime)
        end
      end
    end

    describe '#media_info' do
      subject(:row) { described_class.new(xml) }

      let(:xml) { wrap_row <<~XML }
        <series_animedb_id>#{anime.id}</series_animedb_id>
        <series_title><![CDATA[#{anime.canonical_title}]]></series_title>
        <series_type>#{anime.subtype}</series_type>
        <series_episodes>#{anime.episode_count}</series_episodes>
      XML

      it 'returns the id from series_animedb_id' do
        expect(row.media_info[:id]).to eq(anime.id)
      end

      it 'returns the title from series_itlte' do
        expect(row.media_info[:title]).to eq(anime.canonical_title)
      end

      it 'returns the show type from series_type' do
        expect(row.media_info[:subtype]).to eq(anime.subtype)
      end

      it 'returns the episode count from series_episdes' do
        expect(row.media_info[:episode_count]).to eq(anime.episode_count)
      end
    end

    describe '#status' do
      context 'with a textual my_status' do
        it 'returns :current for "Currently Watching"' do
          xml = wrap_row '<my_status>Currently Watching</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:current)
        end

        it 'returns :planned for "Plan to Watch"' do
          xml = wrap_row '<my_status>Plan to Watch</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:planned)
        end

        it 'returns :completed for "Completed"' do
          xml = wrap_row '<my_status>Completed</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:completed)
        end

        it 'returns :on_hold for "On Hold"' do
          xml = wrap_row '<my_status>On Hold</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:on_hold)
        end

        it 'returns :on_hold for "On-Hold"' do
          xml = wrap_row '<my_status>On-Hold</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:on_hold)
        end

        it 'returns :dropped for "Dropped"' do
          xml = wrap_row '<my_status>Dropped</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:dropped)
        end
      end

      context 'with a numeric my_status' do
        it 'returns :current for 1' do
          xml = wrap_row '<my_status>1</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:current)
        end

        it 'returns :completed for 2' do
          xml = wrap_row '<my_status>2</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:completed)
        end

        it 'returns :on_hold for 3' do
          xml = wrap_row '<my_status>3</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:on_hold)
        end

        it 'returns :dropped for 4' do
          xml = wrap_row '<my_status>4</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:dropped)
        end

        it 'returns nil for 5' do
          xml = wrap_row '<my_status>5</my_status>'
          row = described_class.new(xml)
          expect(row.status).to be_nil
        end

        it 'returns :planned for 6' do
          xml = wrap_row '<my_status>6</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:planned)
        end
      end
    end

    describe '#progress' do
      it 'returns the value in my_watched_episodes' do
        xml = wrap_row '<my_watched_episodes>5</my_watched_episodes>'
        row = described_class.new(xml)
        expect(row.progress).to eq(5)
      end
    end

    describe '#rating' do
      it 'returns twice the value in my_score' do
        xml = wrap_row '<my_score>5</my_score>'
        row = described_class.new(xml)
        expect(row.rating).to eq(10)
      end
    end

    describe '#reconsume_count' do
      it 'returns the value in my_times_watched' do
        xml = wrap_row '<my_times_watched>3</my_times_watched>'
        row = described_class.new(xml)
        expect(row.reconsume_count).to eq(3)
      end
    end

    describe '#notes' do
      context 'when my_tags is blank' do
        it 'returns the value in my_comments' do
          xml = wrap_row <<~XML
            <my_comments><![CDATA[Test]]></my_comments>
            <my_tags><![CDATA[]]></my_tags>
          XML
          row = described_class.new(xml)
          expect(row.notes).to eq('Test')
        end
      end

      context 'when my_comments is blank' do
        it 'returns the value in my_tags with prefix' do
          xml = wrap_row <<~XML
            <my_comments><![CDATA[]]></my_comments>
            <my_tags><![CDATA[Ohai]]></my_tags>
          XML
          row = described_class.new(xml)
          expect(row.notes).to eq("\n=== MAL Tags ===\nOhai")
        end
      end

      context 'when my_comments and my_tags are both blank' do
        it 'returns an empty string' do
          xml = wrap_row <<~XML
            <my_comments><![CDATA[]]></my_comments>
            <my_tags><![CDATA[]]></my_tags>
          XML
          row = described_class.new(xml)
          expect(row.notes).to be_blank
        end
      end

      context 'when my_comments and my_tags are both present' do
        it 'returns both, separated by the prefix' do
          xml = wrap_row <<~XML
            <my_comments><![CDATA[Oha]]></my_comments>
            <my_tags><![CDATA[you]]></my_tags>
          XML
          row = described_class.new(xml)
          expect(row.notes).to eq("Oha\n=== MAL Tags ===\nyou")
        end
      end
    end

    describe '#volumes_owned' do
      it "returns nil because MyAnimeList doesn't have anime volumes" do
        row = described_class.new(wrap_row(''))
        expect(row.volumes_owned).to be_nil
      end
    end

    describe '#started_at' do
      context 'with my_start_date being empty' do
        it 'returns nil' do
          xml = wrap_row '<my_start_date></my_start_date>'
          row = described_class.new(xml)
          expect(row.started_at).to be_nil
        end
      end

      context 'with an invalid date in my_start_date' do
        it 'returns nil' do
          xml = wrap_row '<my_start_date>fuckmyanimelist</my_start_date>'
          row = described_class.new(xml)
          expect(row.started_at).to be_nil
        end
      end

      context 'with a valid ISO 8601 date in my_start_date' do
        it 'returns a date object' do
          xml = wrap_row '<my_start_date>1993-10-11</my_start_date>'
          row = described_class.new(xml)
          expect(row.started_at).to eq(Date.new(1993, 10, 11))
        end
      end
    end

    describe '#finished_at' do
      context 'with my_finish_date being empty' do
        it 'returns nil' do
          xml = wrap_row '<my_finish_date></my_finish_date>'
          row = described_class.new(xml)
          expect(row.finished_at).to be_nil
        end
      end

      context 'with an invalid date in my_finish_date' do
        it 'returns nil' do
          xml = wrap_row '<my_finish_date>fuckmyanimelist</my_finish_date>'
          row = described_class.new(xml)
          expect(row.finished_at).to be_nil
        end
      end

      context 'with a valid ISO 8601 date in my_finish_date' do
        it 'returns a date object' do
          xml = wrap_row '<my_finish_date>1993-10-11</my_finish_date>'
          row = described_class.new(xml)
          expect(row.finished_at).to eq(Date.new(1993, 10, 11))
        end
      end
    end
  end

  context 'with manga' do
    let(:manga) { create(:manga, chapter_count: rand(1..50)) }

    def wrap_row(xml)
      Nokogiri::XML.fragment("<manga>#{xml}</manga>").at_css('manga')
    end

    describe '#type' do
      it 'returns Manga class' do
        row = described_class.new(wrap_row(''))
        expect(row.type).to eq(Manga)
      end
    end

    describe '#media' do
      context 'with a specific Mapping' do
        let(:mapping) { create_mapping(manga) }
        let(:xml) { wrap_row <<~XML }
          <manga_mediadb_id>
            #{mapping.external_id.split('/').last}
          </manga_mediadb_id>
          <manga_title>#{manga.canonical_title}</manga_title>
          <manga_chapters>#{manga.chapter_count}</manga_chapters>
        XML

        it 'returns the Manga instance from the Mapping' do
          row = described_class.new(xml)
          allow(Mapping).to receive(:lookup)
            .with('myanimelist/manga', mapping.external_id.to_i)
            .and_return(manga)
          expect(row.media).to eq(manga)
        end
      end

      context 'without a specific Mapping' do
        let(:xml) { wrap_row <<~XML }
          <manga_mediadb_id>#{rand(1..50_000)}</manga_mediadb_id>
          <manga_title>#{manga.canonical_title}</manga_title>
          <manga_chapters>#{manga.chapter_count}</manga_chapters>
        XML

        it 'guesses the Manga instance using Mapping.guess' do
          row = described_class.new(xml)
          allow(Mapping).to receive(:guess).and_return(manga)
          expect(row.media).to eq(manga)
        end
      end
    end

    describe '#media_info' do
      subject(:row) { described_class.new(xml) }

      let(:xml) { wrap_row <<~XML }
        <manga_mediadb_id>#{manga.id}</manga_mediadb_id>
        <manga_title><![CDATA[#{manga.canonical_title}]]></manga_title>
        <manga_chapters>#{manga.chapter_count}</manga_chapters>
      XML

      it 'returns the id from manga_mediadb_id' do
        expect(row.media_info[:id]).to eq(manga.id)
      end

      it 'returns te title from manga_title' do
        expect(row.media_info[:title]).to eq(manga.canonical_title)
      end

      it 'returns the chapter count from manga_chapters' do
        expect(row.media_info[:chapter_count]).to eq(manga.chapter_count)
      end
    end

    describe '#status' do
      context 'with a textual my_status' do
        it 'returns :current for "Currently Reading"' do
          xml = wrap_row '<my_status>Currently Reading</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:current)
        end

        it 'returns :planned for "Plan to Read"' do
          xml = wrap_row '<my_status>Plan to Read</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:planned)
        end

        it 'returns :completed for "Completed"' do
          xml = wrap_row '<my_status>Completed</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:completed)
        end

        it 'returns :on_hold for "On Hold"' do
          xml = wrap_row '<my_status>On Hold</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:on_hold)
        end

        it 'returns :on_hold for "On-Hold"' do
          xml = wrap_row '<my_status>On-Hold</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:on_hold)
        end

        it 'returns :dropped for "Dropped"' do
          xml = wrap_row '<my_status>Dropped</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:dropped)
        end
      end

      context 'with a numeric my_status' do
        it 'returns :current for 1' do
          xml = wrap_row '<my_status>1</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:current)
        end

        it 'returns :completed for 2' do
          xml = wrap_row '<my_status>2</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:completed)
        end

        it 'returns :on_hold for 3' do
          xml = wrap_row '<my_status>3</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:on_hold)
        end

        it 'returns :dropped for 4' do
          xml = wrap_row '<my_status>4</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:dropped)
        end

        it 'returns nil for 5' do
          xml = wrap_row '<my_status>5</my_status>'
          row = described_class.new(xml)
          expect(row.status).to be_nil
        end

        it 'returns :planned for 6' do
          xml = wrap_row '<my_status>6</my_status>'
          row = described_class.new(xml)
          expect(row.status).to eq(:planned)
        end
      end
    end

    describe '#progress' do
      it 'returns the value in my_read_chapters' do
        xml = wrap_row '<my_read_chapters>5</my_read_chapters>'
        row = described_class.new(xml)
        expect(row.progress).to eq(5)
      end
    end

    describe '#rating' do
      it 'returns twice the value in my_score' do
        xml = wrap_row '<my_score>5</my_score>'
        row = described_class.new(xml)
        expect(row.rating).to eq(10.0)
      end
    end

    describe '#reconsume_count' do
      it 'returns the value in my_times_read' do
        xml = wrap_row '<my_times_read>3</my_times_read>'
        row = described_class.new(xml)
        expect(row.reconsume_count).to eq(3)
      end
    end

    describe '#notes' do
      context 'when my_tags is blank' do
        it 'returns the value in my_comments' do
          xml = wrap_row <<~XML
            <my_comments><![CDATA[Test]]></my_comments>
            <my_tags><![CDATA[]]></my_tags>
          XML
          row = described_class.new(xml)
          expect(row.notes).to eq('Test')
        end
      end

      context 'when my_comments is blank' do
        it 'returns the value in my_tags with prefix' do
          xml = wrap_row <<~XML
            <my_comments><![CDATA[]]></my_comments>
            <my_tags><![CDATA[Ohai]]></my_tags>
          XML
          row = described_class.new(xml)
          expect(row.notes).to eq("\n=== MAL Tags ===\nOhai")
        end
      end

      context 'when my_comments and my_tags are both blank' do
        it 'returns an empty string' do
          xml = wrap_row <<~XML
            <my_comments><![CDATA[]]></my_comments>
            <my_tags><![CDATA[]]></my_tags>
          XML
          row = described_class.new(xml)
          expect(row.notes).to be_blank
        end
      end

      context 'when my_comments and my_tags are both present' do
        it 'returns both, separated by the prefix' do
          xml = wrap_row <<~XML
            <my_comments><![CDATA[Oha]]></my_comments>
            <my_tags><![CDATA[you]]></my_tags>
          XML
          row = described_class.new(xml)
          expect(row.notes).to eq("Oha\n=== MAL Tags ===\nyou")
        end
      end
    end

    describe '#volumes_owned' do
      it 'returns the value in my_read_volumes' do
        xml = wrap_row '<my_read_volumes>3</my_read_volumes>'
        row = described_class.new(xml)
        expect(row.volumes_owned).to eq(3)
      end
    end

    describe '#started_at' do
      context 'with my_start_date being empty' do
        it 'returns nil' do
          xml = wrap_row '<my_start_date></my_start_date>'
          row = described_class.new(xml)
          expect(row.started_at).to be_nil
        end
      end

      context 'with an invalid date in my_start_date' do
        it 'returns nil' do
          xml = wrap_row '<my_start_date>fuckmyanimelist</my_start_date>'
          row = described_class.new(xml)
          expect(row.started_at).to be_nil
        end
      end

      context 'with a valid ISO 8601 date in my_start_date' do
        it 'returns a date object' do
          xml = wrap_row '<my_start_date>1993-10-11</my_start_date>'
          row = described_class.new(xml)
          expect(row.started_at).to eq(Date.new(1993, 10, 11))
        end
      end
    end

    describe '#finished_at' do
      context 'with my_finish_date being empty' do
        it 'returns nil' do
          xml = wrap_row '<my_finish_date></my_finish_date>'
          row = described_class.new(xml)
          expect(row.finished_at).to be_nil
        end
      end

      context 'with an invalid date in my_finish_date' do
        it 'returns nil' do
          xml = wrap_row '<my_finish_date>fuckmyanimelist</my_finish_date>'
          row = described_class.new(xml)
          expect(row.finished_at).to be_nil
        end
      end

      context 'with a valid ISO 8601 date in my_finish_date' do
        it 'returns a date object' do
          xml = wrap_row '<my_finish_date>1993-10-11</my_finish_date>'
          row = described_class.new(xml)
          expect(row.finished_at).to eq(Date.new(1993, 10, 11))
        end
      end
    end
  end
end
