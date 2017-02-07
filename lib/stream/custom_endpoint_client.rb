module Stream
  class CustomEndpointClient
    class AddStreamHeaders < Faraday::Middleware
      extend Forwardable
      def_delegators :'Faraday::Utils', :parse_query, :build_query

      def initialize(app, options = {})
        super(app)
        @options = OpenStruct.new(options)
      end

      def call(req)
        req[:request_headers]['authorization'] = jwt_token
        req[:request_headers]['stream-auth-type'] = 'jwt'
        params = parse_query(req.url.query) || {}
        params['api_key'] = @options.api_key
        req[:url].query = build_query(params)
        if req.body.present?
          req.body = JSON.dump(req.body)
          req[:request_headers]['Content-Type'] = 'application/json'
        end
        @app.call(req).on_complete do |res|
          content_type = res.response_headers['Content-Type']
          res[:body] = JSON.parse(req[:body]) if /\bjson$/ =~ content_type
        end
      end

      private

      def jwt_token
        Stream::Signer.create_jwt_token('*', '*', @options.api_secret, nil, '*')
      end
    end

    CUSTOM_ENDPOINT_PREFIX = 'https://kitsu.getstream.io/kitsu/'.freeze
    attr_reader :api_key, :api_secret, :options, :http
    %i[get post put patch head].each { |method| delegate method, to: :http }

    def initialize
      @api_key = StreamRails.client.api_key
      @api_secret = StreamRails.client.api_secret
      @options = StreamRails.client.get_http_client.options

      @http = Faraday.new(url: CUSTOM_ENDPOINT_PREFIX) do |conn|
        # Deal with Stream
        conn.use AddStreamHeaders, api_secret: api_secret, api_key: api_key
        # Set timeouts
        conn.options[:open_timeout] = options[:default_timeout]
        conn.options[:timeout] = options[:default_timeout]
        # Set adapter
        conn.adapter Faraday.default_adapter
      end
    end

    def upload_meta(metadata)
      post 'meta/', data: metadata
    end
  end
end
