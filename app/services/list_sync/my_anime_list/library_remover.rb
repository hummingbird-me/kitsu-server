module ListSync
  class MyAnimeList
    class LibraryRemover
      include MechanizedEditPage

      def run!
        check_authentication!

        return if delete_form.nil? && edit_page.uri.to_s.include?('add')

        copy_csrf_token_into(delete_form)
        results_page = delete_form.click_button

        if results_page.at_css('.badresult')
          raise ListSync::RemoteError, results_page.at_css('.badresult').text
        end

        true
      end

      private

      def delete_form
        @delete_form ||= edit_page.form_with(id: 'delete-form')
      end
    end
  end
end
