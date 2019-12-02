class PrevalidateEmail < Action
  HTTP_TIMEOUT = 10.seconds
  API_KEY = ENV['THECHECKER_API_KEY']
  URL = 'https://api.thechecker.co/v2/verify'.freeze
  URL_TEMPLATE = Addressable::Template.new("#{URL}?api_key=#{API_KEY}{&email}").freeze

  parameter :email, required: true

  def call
    { result: result, reason: reason }
  end

  private

  def reason
    ActiveSupport::StringInquirer.new(response_data['reason'])
  end

  def result
    ActiveSupport::StringInquirer.new(response_data['result'])
  end

  def response_data
    return default_unknown_response unless API_KEY

    @response_data ||= HTTP.timeout(HTTP_TIMEOUT).get(url).parse
  rescue HTTP::TimeoutError => e
    Raven.capture_exception(e)
    @response_data ||= default_unknown_response
  end

  def default_unknown_response
    {
      'result': 'unknown',
      'reason': 'timeout',
      'email': email
    }
  end

  def url
    @url ||= URL_TEMPLATE.expand(email: email)
  end
end
