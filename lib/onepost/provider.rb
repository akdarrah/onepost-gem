module Onepost
  module Provider
    extend ActiveSupport::Concern

    included do
      def get_providers(options={})
        url     = construct_url("api/v1/providers")
        query   = default_query.merge(options.fetch(:query, {}))
        body    = default_body.merge(options.fetch(:body, {}))
        headers = default_headers.merge(options.fetch(:headers, {}))

        response = HTTParty.get(url, {
          query: query,
          body: body,
          headers: headers,
          timeout: Onepost::Client::TIMEOUT
        })

        JSON.parse(response.body)
      end

      def get_provider(id, options={})
        url     = construct_url("api/v1/providers/#{id}")
        query   = default_query.merge(options.fetch(:query, {}))
        body    = default_body.merge(options.fetch(:body, {}))
        headers = default_headers.merge(options.fetch(:headers, {}))

        response = HTTParty.get(url, {
          query: query,
          body: body,
          headers: headers,
          timeout: Onepost::Client::TIMEOUT
        })

        JSON.parse(response.body)
      end

      def create_provider(params, options={})
        data = {
          "provider[type]"           => params.fetch(:type),
          "provider[api_key]"        => params.fetch(:api_key),
          "provider[api_secret_key]" => params.fetch(:api_secret_key),
          "provider[callback_url]"   => params.fetch(:callback_url, nil)
        }

        url     = construct_url("api/v1/providers")
        query   = default_query.merge(options.fetch(:query, {}))
        body    = URI.encode_www_form(data)
        headers = default_headers.merge(options.fetch(:headers, {}))

        response = HTTParty.post(url, {
          query: query,
          body: body,
          headers: headers,
          timeout: Onepost::Client::TIMEOUT
        })

        JSON.parse(response.body)
      end

      def delete_provider(id, options={})
        url     = construct_url("api/v1/providers/#{id}")
        query   = default_query.merge(options.fetch(:query, {}))
        body    = default_body.merge(options.fetch(:body, {}))
        headers = default_headers.merge(options.fetch(:headers, {}))

        response = HTTParty.delete(url, {
          query: query,
          body: body,
          headers: headers,
          timeout: Onepost::Client::TIMEOUT
        })

        JSON.parse(response.body)
      end
    end
  end
end
