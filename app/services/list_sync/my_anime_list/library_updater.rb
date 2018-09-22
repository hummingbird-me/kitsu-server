module ListSync
  class MyAnimeList
    class LibraryUpdater
      include MechanizedEditPage

      attr_reader :library_entry

      def initialize(agent, library_entry)
        super(agent, library_entry.media)
        @library_entry = library_entry
      end

      def run!
        check_authentication!
        fill_form
        copy_csrf_token_into(update_form)
        results_page = update_form.click_button

        raise_for(results_page.at_css('.badresult').text) if results_page.at_css('.badresult')

        true
      end

      private

      def raise_for(badresult)
        case badresult
        when /Failed to add/i
          begin
            # Check if the media no longer exists
            agent.get("https://myanimelist.net/#{media_kind}/#{mal_id}/found")
          rescue Mechanize::ResponseCodeError
            # If we 404'd then destroy the mapping and raise a NotFoundError
            mal_mapping&.destroy!
            raise ListSync::NotFoundError
          end
        else
          # If we dunno the error, just raise a generic one
          raise ListSync::RemoteError, badresult
        end
      end

      def fill_form
        fill_status
        fill_progress
        fill_rating
        fill_start_date
        fill_end_date
        fill_rewatches
      end

      def fill_status
        field_for(:status).value = mal_status_key
      end

      def fill_progress
        if library_entry.kind == :anime
          field_for(:num_watched_episodes).value = library_entry.progress
        elsif library_entry.kind == :manga
          field_for(:num_read_chapters).value = library_entry.progress
          field_for(:num_read_volumes).value = library_entry.volumes_owned
        end
      end

      def fill_rating
        return unless library_entry.rating

        field_for(:score).value = library_entry.rating / 2
      end

      def fill_start_date
        return unless library_entry.started_at

        field_for(:start_date, :year).value = library_entry.started_at.year
        field_for(:start_date, :month).value = library_entry.started_at.month
        field_for(:start_date, :day).value = library_entry.started_at.day
      end

      def fill_end_date
        return unless library_entry.finished_at

        finish_date = library_entry.finished_at
        field_for(:finish_date, :year).value = finish_date.year
        field_for(:finish_date, :month).value = finish_date.month
        field_for(:finish_date, :day).value = finish_date.day
      end

      def fill_rewatches
        if library_entry.kind == :anime
          field_for(:num_watched_times).value = library_entry.reconsume_count
        elsif library_entry.kind == :manga
          field_for(:num_read_times).value = library_entry.reconsume_count
        end
      end

      def mal_status_key
        case library_entry.status.to_s
        when 'current' then 1
        when 'completed' then 2
        when 'on_hold' then 3
        when 'dropped' then 4
        when 'planned' then 6
        end
      end

      def field_for(*path)
        field_path = path.map { |key| "[#{key}]" }.join
        field_name = "#{form_name}#{field_path}"
        update_form.field_with(name: field_name)
      end

      def update_form
        @update_form ||= edit_page.form_with(id: 'main-form')
      end

      def form_name
        @form_name ||= update_form.name
      end
    end
  end
end
