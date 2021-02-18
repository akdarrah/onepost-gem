require "test_helper"

class OnepostSocialPostTest < Minitest::Test
  def setup
    @client = Onepost::Client.new(
      rapid_api_key: "12345",
      secret_key: "67890"
    )
  end

  def test_can_fetch_all_social_posts
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/social_posts?secret_key=67890")
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
      .to_return(status: 200, body: example_social_posts_data.to_json, headers: {})

    data = @client.get_social_posts
    assert_equal 2, data["collection"].count
  end

  def test_can_fetch_a_social_post
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/social_posts/2?secret_key=67890")
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
      .to_return(status: 200, body: example_social_post_data.to_json, headers: {})

    data = @client.get_social_post(2)
    assert_equal 2, data["id"]
  end

  private

  def example_social_posts_data
    {
      "current_page"=>1,
      "per_page"=>30,
      "total_entries"=>2,
      "collection"=>[
        {
          "id"=>2,
          "post_id"=>2,
          "created_at"=>"2021-02-12T13:19:38.771-05:00",
          "updated_at"=>"2021-02-12T13:19:49.642-05:00",
          "type"=>"SocialPosts::Facebook",
          "state"=>"sent",
          "authorized_page_id"=>2,
          "service_data"=>nil,
          "service_data_updated_at"=>nil
        },
        {
          "id"=>3,
          "post_id"=>3,
          "created_at"=>"2021-02-12T13:20:56.454-05:00",
          "updated_at"=>"2021-02-12T13:21:20.939-05:00",
          "type"=>"SocialPosts::Instagram",
          "state"=>"sent",
          "authorized_page_id"=>3,
          "service_data"=>nil,
          "service_data_updated_at"=>nil
        }
      ]
    }
  end

  def example_social_post_data
    {
      "id"=>2,
      "post_id"=>2,
      "created_at"=>"2021-02-12T13:19:38.771-05:00",
      "updated_at"=>"2021-02-12T13:19:49.642-05:00",
      "type"=>"SocialPosts::Facebook",
      "state"=>"sent",
      "authorized_page_id"=>2,
      "service_data"=>nil,
      "service_data_updated_at"=>nil
    }
  end
end
