module Onepost
  module Post
    extend ActiveSupport::Concern

    included do
      def get_posts(options={})
        url     = construct_url("api/v1/posts")
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

      def get_post(id, options={})
        url     = construct_url("api/v1/posts/#{id}")
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
    end
  end
end
