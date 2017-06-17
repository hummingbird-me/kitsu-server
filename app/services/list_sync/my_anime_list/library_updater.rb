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

        if results_page.at_css('.badresult')
          raise ListSync::RemoteError, results_page.at_css('.badresult').text
        end
        true
      end

      private

      def fill_form
        # Status
        field_for(:status).value = mal_status_key
        # Progress
        if library_entry.kind == :anime
          field_for(:num_watched_episodes).value = library_entry.progress
        elsif library_entry.kind == :manga
          field_for(:num_read_chapters).value = library_entry.progress
          field_for(:num_read_volumes).value = library_entry.volumes_owned
        end
        # Rating
        if library_entry.rating
          field_for(:score).value = library_entry.rating / 2
        end
        # Start Date
        if library_entry.started_at
          field_for(:start_date, :year).value = library_entry.started_at.year
          field_for(:start_date, :month).value = library_entry.started_at.month
          field_for(:start_date, :day).value = library_entry.started_at.day
        end
        # End Date
        if library_entry.finished_at
          finish_date = library_entry.finished_at
          field_for(:finish_date, :year).value = finish_date.year
          field_for(:finish_date, :month).value = finish_date.month
          field_for(:finish_date, :day).value = finish_date.day
        end
        # Rewatches/rewatches
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
