module Onepost
  class Client
    include Onepost::Provider
    include Onepost::Authorization
    include Onepost::AuthorizedPage

    RAPID_API_HOST = "onepost1.p.rapidapi.com"
    TIMEOUT = 180

    attr_accessor :rapid_api_key, :secret_key

    def initialize(data={})
      self.rapid_api_key = data.fetch(:rapid_api_key)
      self.secret_key = data.fetch(:secret_key)
    end

    private

    def default_query
      {
        "secret_key" => secret_key
      }
    end

    def default_body
      {}
    end

    def default_headers
      {
        "Content-Type"    => "application/json",
        "x-rapidapi-key"  => rapid_api_key,
        "x-rapidapi-host" => Onepost::Client::RAPID_API_HOST
      }
    end

    def construct_url(endpoint)
      "https://#{RAPID_API_HOST}/#{endpoint}"
    end
  end
end
