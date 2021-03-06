require "test_helper"

class OnepostWebhookTest < Minitest::Test
  def setup
    @client = Onepost::Client.new(
      rapid_api_key: "12345",
      secret_key: "67890"
    )
  end

  def test_can_fetch_all_webhooks
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/webhooks?secret_key=67890")
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
      .to_return(status: 200, body: example_webhooks_data.to_json, headers: {})

    data = @client.get_webhooks
    assert_equal 1, data["collection"].count
  end

  def test_can_fetch_a_single_webhook
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/webhooks/2?secret_key=67890")
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
      .to_return(status: 200, body: example_webhook_data.to_json, headers: {})

    data = @client.get_webhook(2)
    assert_equal 2, data["id"]
  end

  def test_can_create_a_webhook
    stub_request(:post, "https://onepost1.p.rapidapi.com/api/v1/webhooks?secret_key=67890")
      .with(
        body: "{\"webhook\":{\"endpoint_url\":\"https://webhook.site/3f338283-10b0-492a-a97e\"}}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
        }
      )
      .to_return(status: 200, body: example_webhook_data.to_json, headers: {})

    data = @client.create_webhook(
      body: {
        "webhook": {
          "endpoint_url": "https://webhook.site/3f338283-10b0-492a-a97e"
        }
      }
    )
    assert_equal 2, data["id"]
  end

  def test_can_update_a_webhook
    stub_request(:put, "https://onepost1.p.rapidapi.com/api/v1/webhooks/2?secret_key=67890")
      .with(
        body: "{\"webhook\":{\"endpoint_url\":\"https://webhook.site/3f338283-10b0-492a\"}}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
        }
      )
      .to_return(status: 200, body: example_webhook_data.to_json, headers: {})

    data = @client.update_webhook(2, body: {
      "webhook": {
        "endpoint_url": "https://webhook.site/3f338283-10b0-492a"
      }
    })
    assert_equal 2, data["id"]
  end

  def test_can_delete_a_webhook
    stub_request(:delete, "https://onepost1.p.rapidapi.com/api/v1/webhooks/2?secret_key=67890")
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
      .to_return(status: 200, body: example_webhook_data.to_json, headers: {})

    data = @client.delete_webhook(2)
    assert_equal 2, data["id"]
  end

  private

  def example_webhooks_data
    {
      "current_page"=>1,
      "per_page"=>30,
      "total_entries"=>1,
      "collection"=>[
        {
          "id"=>2,
          "endpoint_url"=>"https://webhook.site/3f338283-10b0-492a-a97e",
          "created_at"=>"2021-02-16T17:46:58.911-05:00",
          "updated_at"=>"2021-02-16T17:46:58.911-05:00"
        }
      ]
    }
  end

  def example_webhook_data
    {
      "id"=>2,
      "endpoint_url"=>"https://webhook.site/3f338283-10b0-492a-a97e",
      "created_at"=>"2021-02-16T17:46:58.911-05:00",
      "updated_at"=>"2021-02-16T17:46:58.911-05:00"
    }
  end
end
