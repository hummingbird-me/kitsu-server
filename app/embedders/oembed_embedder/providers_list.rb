class OembedEmbedder
  class ProvidersList
    # The source of the providers list on oembed.com
    PROVIDERS_URL = 'https://oembed.com/providers.json'.freeze

    # @param list [Array<Hash>] the list of providers from oembed.com
    def initialize(list)
      @list = list
    end

    # @return [Hash<Regex,Hash>] the list of endpoints keyed by regular expressions of their schemes
    def providers
      @providers ||= @list.each_with_object({}) do |provider, out|
        provider['endpoints'].each do |endpoint|
          next unless endpoint['schemes']
          endpoint_url = endpoint['url'].sub('{format}', 'json')
          endpoint['schemes'].each do |scheme|
            out[scheme_to_regex(scheme)] = endpoint_url
          end
        end
      end
    end

    # @param url [String] the URL to find a provider for
    # @return [String] the oEmbed URL for this URL
    def for_url(url)
      oembed_url = providers.find { |schema, _| schema =~ url }&.last
      return nil unless oembed_url
      oembed_url = Addressable::URI.parse(oembed_url)
      oembed_url.query_values = (oembed_url.query_values || {}).merge(url: url)
      oembed_url.to_s
    end

    # @return [Hash<Regex,Hash>] a cached list of endpoints for oembed lookup
    def self.providers
      @providers ||= new(JSON.parse(EmbedService.get(PROVIDERS_URL)))
    end

    private

    # @param scheme [String] the glob string to convert to a regular expression
    # @return [Regex] a regular expression to match the scheme
    def scheme_to_regex(scheme)
      Regexp.new(scheme.gsub('*', '.*').sub(/\Ahttps?/, 'https?'), Regexp::IGNORECASE)
    end
  end
end
