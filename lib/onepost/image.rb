module Onepost
  module Image
    extend ActiveSupport::Concern

    included do
      def get_images(options={})
        url     = construct_url("api/v1/images")
        query   = default_query.merge(options.fetch(:query, {}))
        body    = default_body.merge(options.fetch(:body, {}))
        headers = default_headers.merge(options.fetch(:headers, {}))

        response = HTTParty.get(url, {
          query: query,
          body: body.to_json,
          headers: headers,
          timeout: Onepost::Client::TIMEOUT
        })

        JSON.parse(response.body)
      end

      def get_image(id, options={})
        url     = construct_url("api/v1/images/#{id}")
        query   = default_query.merge(options.fetch(:query, {}))
        body    = default_body.merge(options.fetch(:body, {}))
        headers = default_headers.merge(options.fetch(:headers, {}))

        response = HTTParty.get(url, {
          query: query,
          body: body.to_json,
          headers: headers,
          timeout: Onepost::Client::TIMEOUT
        })

        JSON.parse(response.body)
      end

      def create_image(options={})
        url     = construct_url("api/v1/images")
        query   = default_query.merge(options.fetch(:query, {}))
        body    = default_body.merge(options.fetch(:body, {}))
        headers = default_headers.merge(options.fetch(:headers, {}))

        if headers["Content-Type"] == Onepost::Client::JSON_CONTENT_TYPE
          body = body.to_json
        end

        response = HTTParty.post(url, {
          query: query,
          body: body,
          headers: headers,
          timeout: Onepost::Client::TIMEOUT
        })

        JSON.parse(response.body)
      end

      def update_image(id, options={})
        url     = construct_url("api/v1/images/#{id}")
        query   = default_query.merge(options.fetch(:query, {}))
        body    = default_body.merge(options.fetch(:body, {}))
        headers = default_headers.merge(options.fetch(:headers, {}))

        response = HTTParty.put(url, {
          query: query,
          body: body.to_json,
          headers: headers,
          timeout: Onepost::Client::TIMEOUT
        })

        JSON.parse(response.body)
      end

      def delete_image(id, options={})
        url     = construct_url("api/v1/images/#{id}")
        query   = default_query.merge(options.fetch(:query, {}))
        body    = default_body.merge(options.fetch(:body, {}))
        headers = default_headers.merge(options.fetch(:headers, {}))

        response = HTTParty.delete(url, {
          query: query,
          body: body.to_json,
          headers: headers,
          timeout: Onepost::Client::TIMEOUT
        })

        JSON.parse(response.body)
      end
    end
  end
end
