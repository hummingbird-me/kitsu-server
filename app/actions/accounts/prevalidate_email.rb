module Accounts
  class PrevalidateEmail < Action
    class EmailableError < StandardError; end

    HTTP_TIMEOUT = 10.seconds
    API_KEY = ENV['EMAILABLE_API_KEY']
    URL = 'https://api.emailable.com/v1/verify'.freeze
    URL_TEMPLATE = Addressable::Template.new("#{URL}?api_key=#{API_KEY}{&email}").freeze

    parameter :email, required: true

    def call
      { result: result, reason: reason }
    end

    private

    def reason
      ActiveSupport::StringInquirer.new(response_data['reason'] || '')
    end

    def result
      ActiveSupport::StringInquirer.new(response_data['state'] || '')
    end

    def response_data
      return @response_data if @response_data
      return @response_data = default_unknown_response_for('unauthorized') unless API_KEY

      response = HTTP.timeout(HTTP_TIMEOUT.to_i).get(url)

      if response.status == 200
        @response_data = response.parse
      else
        Raven.capture_exception(EmailableError.new, extra: {
          response_status: response.status,
          response_data: response.parse
        })
        @response_data = default_unknown_response_for('bad_gateway')
      end
    rescue HTTP::TimeoutError => e
      Raven.capture_exception(e)
      @response_data = default_unknown_response_for('timeout')
    end

    def default_unknown_response_for(reason)
      {
        'state' => 'unknown',
        'reason' => reason,
        'email' => email
      }
    end

    def url
      @url ||= URL_TEMPLATE.expand(email: email)
    end
  end
end
