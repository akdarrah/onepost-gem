require "test_helper"

class OnepostPostIntentTest < Minitest::Test
  def setup
    @client = Onepost::Client.new(
      rapid_api_key: "12345",
      secret_key: "67890"
    )
  end

  def test_can_fetch_one_post_intent
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/post_intents/5uf634b05787013904b52cde48101122?secret_key=67890")
      .with(
        body: "{}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
        })
        .to_return(status: 200, body: example_post_intent_data.to_json, headers: {})

    data = @client.get_post_intent("5uf634b05787013904b52cde48101122")
    assert_equal "5uf634b05787013904b52cde48101122", data["token"]
  end

  private

  def example_post_intent_data
    {
      "token"=>"5uf634b05787013904b52cde48101122",
      "body"=>"Testing from Production",
      "created_at"=>"2021-02-12T12:02:45.182-05:00",
      "updated_at"=>"2021-02-12T12:02:55.467-05:00",
      "state"=>"published",
      "publish_at"=>nil,
      "authorized_page_ids"=>[],
      "image_url"=>nil,
      "social_posts"=>[]
    }
  end
end
