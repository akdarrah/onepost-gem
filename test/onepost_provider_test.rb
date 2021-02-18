require "test_helper"

class OnepostProviderTest < Minitest::Test
  def setup
    @client = Onepost::Client.new(
      rapid_api_key: "12345",
      secret_key: "67890"
    )
  end

  # Onepost::Provider#get_providers

  def test_can_fetch_all_providers_data
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/providers?secret_key=67890")
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'}
      )
      .to_return(status: 200, body: get_providers_data.to_json, headers: {})

    data = @client.get_providers
    assert_equal 2, data["collection"].count
  end

  def test_can_fetch_single_provider_data
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/providers/1?secret_key=67890")
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
        }
      )
      .to_return(status: 200, body: get_provider_data.to_json, headers: {})

    data = @client.get_provider(1)
    assert_equal 1, data["id"]
  end

  def test_can_delete_a_provider
    stub_request(:delete, "https://onepost1.p.rapidapi.com/api/v1/providers/1?secret_key=67890")
      .with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
        }
      )
      .to_return(status: 200, body: get_provider_data.to_json, headers: {})

    data = @client.delete_provider(1)
    assert_equal 1, data["id"]
  end

  private

  def get_providers_data
    {
      "current_page"=>1,
      "per_page"=>30,
      "total_entries"=>2,
      "collection"=>[
        {
          "id"=>1,
          "type"=>"Providers::Facebook",
          "api_key"=>"277...",
          "created_at"=>"2021-02-12T11:21:34.171-05:00",
          "updated_at"=>"2021-02-12T11:21:34.171-05:00",
          "callback_url"=>"http://google.com",
          "api_secret_key"=>"42d..."
        },
        {
          "id"=>2,
          "type"=>"Providers::Twitter",
          "api_key"=>"edw...",
          "created_at"=>"2021-02-12T11:27:39.999-05:00",
          "updated_at"=>"2021-02-12T11:27:39.999-05:00",
          "callback_url"=>"http://google.com",
          "api_secret_key"=>"XVI..."
        }
      ]
    }
  end

  def get_provider_data
    {
      "id"=>1,
      "type"=>"Providers::Facebook",
      "api_key"=>"277...",
      "created_at"=>"2021-02-12T11:21:34.171-05:00",
      "updated_at"=>"2021-02-12T11:21:34.171-05:00",
      "callback_url"=>"http://google.com",
      "api_secret_key"=>"42d..."
    }
  end
end
