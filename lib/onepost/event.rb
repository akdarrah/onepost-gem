module Onepost
  module Event
    extend ActiveSupport::Concern

    included do
      def get_events(options={})
        url     = construct_url("api/v1/events")
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
