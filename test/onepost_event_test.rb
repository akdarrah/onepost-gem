require "test_helper"

class OnepostEventTest < Minitest::Test
  def setup
    @client = Onepost::Client.new(
      rapid_api_key: "12345",
      secret_key: "67890"
    )
  end

  def test_can_fetch_all_events
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/events?secret_key=67890")
      .with(
        body: "{}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
        }
      )
      .to_return(status: 200, body: example_events_data.to_json, headers: {})

    data = @client.get_events
    assert_equal 1, data["collection"].count
  end

  def test_can_fetch_an_event
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/events/1?secret_key=67890")
      .with(
        body: "{}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
        }
      )
      .to_return(status: 200, body: example_event_data.to_json, headers: {})

    data = @client.get_event(1)
    assert_equal 1, data["id"]
  end

  def test_can_create_a_test_event
    stub_request(:post, "https://onepost1.p.rapidapi.com/api/v1/events/test?secret_key=67890")
      .with(
        body: "{}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
        }
      )
      .to_return(status: 200, body: example_event_data.to_json, headers: {})

    data = @client.create_test_event
    assert_equal 1, data["id"]
  end

  private

  def example_events_data
    {
      "current_page"=>1,
      "per_page"=>30,
      "total_entries"=>1,
      "collection"=>[
        {
          "id"=>1,
          "name"=>"events.test",
          "data"=>{
            "object"=>{
              "ping"=>"pong"
            }
          },
          "created_at"=>"2021-02-16T17:47:41.276-05:00",
          "updated_at"=>"2021-02-16T17:47:41.276-05:00",
          "webhook_attempts"=>[
            {
              "id"=>1,
              "state"=>"succeeded",
              "created_at"=>"2021-02-16T17:47:41.360-05:00",
              "updated_at"=>"2021-02-16T17:47:41.908-05:00",
              "number_of_attempted_requests"=>1,
              "webhook"=>{
                "id"=>2,
                "endpoint_url"=>"https://webhook.site/3f338283-10b0-492a-a97e-d891d538ab79",
                "created_at"=>"2021-02-16T17:46:58.911-05:00",
                "updated_at"=>"2021-02-16T17:46:58.911-05:00"
              },
              "last_request"=>{
                "id"=>1,
                "response_body"=>"",
                "status"=>200,
                "created_at"=>"2021-02-16T17:47:41.449-05:00",
                "updated_at"=>"2021-02-16T17:47:41.449-05:00"
              }
            }
          ]
        }
      ]
    }
  end

  def example_event_data
    {
      "id"=>1,
      "name"=>"events.test",
      "data"=>{
        "object"=>{
          "ping"=>"pong"
        }
      },
      "created_at"=>"2021-02-16T17:47:41.276-05:00",
      "updated_at"=>"2021-02-16T17:47:41.276-05:00",
      "webhook_attempts"=>[
        {
          "id"=>1,
          "state"=>"succeeded",
          "created_at"=>"2021-02-16T17:47:41.360-05:00",
          "updated_at"=>"2021-02-16T17:47:41.908-05:00",
          "number_of_attempted_requests"=>1,
          "webhook"=>{
            "id"=>2,
            "endpoint_url"=>"https://webhook.site/3f338283-10b0-492a-a97e-d891d538ab79",
            "created_at"=>"2021-02-16T17:46:58.911-05:00",
            "updated_at"=>"2021-02-16T17:46:58.911-05:00"
          },
          "last_request"=>{
            "id"=>1,
            "response_body"=>"",
            "status"=>200,
            "created_at"=>"2021-02-16T17:47:41.449-05:00",
            "updated_at"=>"2021-02-16T17:47:41.449-05:00"
          }
        }
      ]
    }
  end
end
