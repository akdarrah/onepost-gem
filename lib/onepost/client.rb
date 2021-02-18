module Onepost
  class Client
    include Onepost::Provider

    RAPID_API_HOST = "onepost1.p.rapidapi.com"

    attr_accessor :rapid_api_key, :secret_key

    def initialize(data={})
      self.rapid_api_key = data.fetch(:rapid_api_key)
      self.secret_key = data.fetch(:secret_key)
    end
  end
end
