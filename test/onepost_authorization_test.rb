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

  def test_can_create_new_authorization
    stub_request(:post, "https://onepost1.p.rapidapi.com/api/v1/authorizations?secret_key=67890")
      .with(
        body: "{\"authorization\":{\"provider_id\":4}}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
        }
      )
      .to_return(status: 200, body: example_authorization_create_data.to_json, headers: {})

    data = @client.create_authorization(body: {
      authorization: {
        provider_id: 4
      }
    })
    assert data["url"].present?
  end

  def test_can_delete_an_authorization
    stub_request(:delete, "https://onepost1.p.rapidapi.com/api/v1/authorizations/2?secret_key=67890")
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

    data = @client.delete_authorization(2)
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

  def example_authorization_create_data
    {
      "instructions"=>[
        "Perform the following steps to complete the authorization process:",
        "  1. In your web browser, navigate to the provided URL.",
        "  2. Sign in to Twitter.",
        "  3. You will be redirected back to the original application."
      ],
      "url"=>"https://api.getonepost.com/users/auth/twitter?provider_id=4&public_key=pk-4a0986d0-9895-0239-b374-76de50b5e55c"
    }
  end
end
