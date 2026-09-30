require 'uri'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/hash/keys'

module SmtpURL
  class Parser

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
      raise InvalidUrlException, "Improper format of SMTP_URL env var, must be smtp://" unless parsed_url.scheme == 'smtp'
      parsed_url
    rescue URI::InvalidURIError => e
      raise InvalidUrlException, "Could not parse SMTP_URL env var"
    end

    def build_hash(config, query)
      {
        :address        => config.host,
        :port           => config.port || 25,
        :domain         => query[:domain],
        :user_name      => decode(config.user),
        :password       => decode(config.password),
        :authentication => query[:authentication].try(:to_sym)
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
