require "test_helper"

class OnepostAuthorizationTest < Minitest::Test
  def setup
    @client = Onepost::Client.new(
      rapid_api_key: "12345",
      secret_key: "67890"
    )
  end

  def test_can_fetch_all_authorizations
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/authorizations?secret_key=67890")
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
      .to_return(status: 200, body: example_authorizations_data.to_json, headers: {})

    data = @client.get_authorizations
    assert_equal 1, data["collection"].count
  end

  def test_can_fetch_a_single_authorizations
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/authorizations/2?secret_key=67890")
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
      ).to_return(status: 200, body: example_authorization_data.to_json, headers: {})

    data = @client.get_authorization(2)
    assert_equal 2, data["id"]
  end

  private

  def example_authorizations_data
    {
      "current_page"=>1,
      "per_page"=>30,
      "total_entries"=>1,
      "collection"=>[
        {
          "id"=>2,
          "created_at"=>"2021-02-12T13:18:47.905-05:00",
          "updated_at"=>"2021-02-12T13:18:47.905-05:00",
          "provider_id"=>1,
          "type"=>"Authorizations::Facebook",
          "consumer_key"=>"EAA...",
          "consumer_secret"=>nil,
          "authorized_pages"=>[{"id"=>2}]
        }
      ]
    }
  end

  def example_authorization_data
    {
      "id"=>2,
      "created_at"=>"2021-02-12T13:18:47.905-05:00",
      "updated_at"=>"2021-02-12T13:18:47.905-05:00",
      "provider_id"=>1,
      "type"=>"Authorizations::Facebook",
      "consumer_key"=>"EAA...",
      "consumer_secret"=>nil,
      "authorized_pages"=>[{"id"=>2}]
    }
  end
end
