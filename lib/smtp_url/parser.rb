require 'uri'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/hash/keys'

module SmtpURL
  class Parser
    # default port of each scheme: smtps is SMTP over implicit TLS (RFC 8314)
    DEFAULT_PORTS = { 'smtp' => 25, 'smtps' => 465 }.freeze

    def initialize(url)
      @url = url
    end

    def parse
      config = parse_url
      query = split_query_params(config.query)
      settings = build_hash(config, query)
      settings.reject!{ |key,value| value.nil? }
      settings
    end

    private

    def parse_url
      parsed_url = URI.parse(@url)
      raise InvalidUrlException, "Improper format of SMTP_URL env var, must be smtp:// or smtps://" unless DEFAULT_PORTS.key?(parsed_url.scheme)
      parsed_url
    rescue URI::InvalidURIError => e
      raise InvalidUrlException, "Could not parse SMTP_URL env var"
    end

    def build_hash(config, query)
      {
        :address        => config.host,
        :port           => config.port || DEFAULT_PORTS[config.scheme],
        :domain         => query[:domain],
        :user_name      => decode(config.user),
        :password       => decode(config.password),
        :authentication => query[:authentication].try(:to_sym),
        :tls            => (true if config.scheme == 'smtps')
      }
    end

    # userinfo is percent-encoded (RFC 3986): a '+' is a plus sign, not a space
    def decode(component)
      component && URI.decode_uri_component(component)
    end

    def split_query_params(query = nil)
      return {} unless query
      Hash[query.split("&").map{ |pair| pair.split("=") }].symbolize_keys
    end
  end
end
