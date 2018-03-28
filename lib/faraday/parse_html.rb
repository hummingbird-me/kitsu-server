require 'faraday_middleware/response_middleware'

module Faraday
  # Public: parses response bodies with Nokogiri.
  class ParseHtml < FaradayMiddleware::ResponseMiddleware
    dependency 'nokogiri'

    define_parser { |body| Nokogiri::HTML(body) }
  end
end
