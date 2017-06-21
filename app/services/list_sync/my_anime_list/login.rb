module ListSync
  class MyAnimeList
    class Login
      attr_reader :error_message

      def initialize(agent, username, password)
        @agent = agent
        @username = username
        @password = password
      end

      def success?
        sign_in
        @signed_in
      end

      private

      def sign_in
        return @signed_in unless @signed_in.nil?

        @agent.get('https://myanimelist.net/login.php') do |login_page|
          # Already logged in!
          if login_page.uri.to_s == 'https://myanimelist.net/'
            return @signed_in = true
          end
          login_form = login_page.form_with(name: 'loginForm') do |form|
            form['csrf_token'] = csrf_token_on(login_page)
            form.user_name = @username
            form.password = @password
          end
          login_response = login_form.submit
          if login_response.uri.to_s.include?('login.php')
            @error_message = login_response.at_css('.badresult').content
            @signed_in = false
          else
            @signed_in = true
          end
        end
      end

      def csrf_token_on(page)
        page.search('meta[name="csrf_token"]').first['content']
      end
    end
  end
end
