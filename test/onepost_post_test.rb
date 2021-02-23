require "test_helper"

class OnepostPostTest < Minitest::Test
  def setup
    @client = Onepost::Client.new(
      rapid_api_key: "12345",
      secret_key: "67890"
    )
  end

  def test_can_fetch_all_posts
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/posts?secret_key=67890")
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
      ).to_return(status: 200, body: example_posts_data.to_json, headers: {})

    data = @client.get_posts
    assert_equal 3, data["collection"].count
  end

  def test_can_fetch_one_post
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/posts/1?secret_key=67890")
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
      ).to_return(status: 200, body: example_post_data.to_json, headers: {})

    data = @client.get_post(1)
    assert_equal 1, data["id"]
  end

  def test_can_create_a_new_post
    stub_request(:post, "https://onepost1.p.rapidapi.com/api/v1/posts?secret_key=67890")
      .with(
        body: "{\"post\":{\"body\":\"I am the night\",\"authorized_page_ids\":[5],\"image_url\":\"https://fastly.syfy.com/sites/syfy/files/styles/1200x680/public/2017/12/screen_shot_2017-12-01_at_10.16.58_am.png\",\"publish_at\":\"2021-02-11T10:27:55-05:00\"}}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
        }
      ).to_return(status: 200, body: example_post_data.to_json, headers: {})

    data = @client.create_post(
      body: {
        "post": {
          "body": "I am the night",
          "authorized_page_ids": [5],
          "image_url": "https://fastly.syfy.com/sites/syfy/files/styles/1200x680/public/2017/12/screen_shot_2017-12-01_at_10.16.58_am.png",
          "publish_at": "2021-02-11T10:27:55-05:00"
        }
      }
    )
    assert_equal 1, data["id"]
  end

  def test_can_create_a_new_post_with_image_upload
    skip "WebMock does not support matching body for multipart/form-data requests yet :("

    stub_request(:post, "https://onepost1.p.rapidapi.com/api/v1/posts?secret_key=67890")
      .with(
        body: "post%5Bbody%5D=Red%20Rocks%21&post%5Bauthorized_page_ids%5D%5B%5D=10&post%5Bauthorized_page_ids%5D%5B%5D=11&post%5Bimage%5D=%2FUsers%2Fadam%2FDeveloper%2Fonepost%2Fonepost-gem%2Ftest%2Ffiles%2Fredrocks.jpg",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'multipart/form-data',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
        }
      )
      .to_return(status: 200, body: example_post_data.to_json, headers: {})

    data = @client.create_post(
      headers: {
        "Content-Type" => "multipart/form-data"
      },
      body: {
        post: {
          body: "Red Rocks!",
          authorized_page_ids: [10, 11],
          image: File.join(Dir.pwd, "test/files/redrocks.jpg")
        }
      }
    )
    assert_equal 1, data["id"]
  end

  def test_can_update_a_post
    stub_request(:put, "https://onepost1.p.rapidapi.com/api/v1/posts/5?secret_key=67890")
      .with(
        body: "{\"post\":{\"body\":\"Batmannn\"}}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
        }
      )
      .to_return(status: 200, body: example_post_data.to_json, headers: {})

    data = @client.update_post(5, body: {
      "post": {
        "body": "Batmannn"
      }
    })
    assert_equal 1, data["id"]
  end

  def test_can_delete_a_post
    stub_request(:delete, "https://onepost1.p.rapidapi.com/api/v1/posts/1?secret_key=67890")
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
      ).to_return(status: 200, body: example_post_data.to_json, headers: {})

    data = @client.delete_post(1)
    assert_equal 1, data["id"]
  end

  def test_can_publish_a_post
    stub_request(:post, "https://onepost1.p.rapidapi.com/api/v1/posts/1/publish?secret_key=67890")
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
      .to_return(status: 200, body: example_post_data.to_json, headers: {})

    data = @client.publish_post(1)
    assert_equal 1, data["id"]
  end

  private

  def example_posts_data
    {
      "current_page"=>1,
      "per_page"=>30,
      "total_entries"=>3,
      "collection"=>[
        {
          "id"=>1,
          "body"=>"Testing from Production",
          "created_at"=>"2021-02-12T12:02:45.182-05:00",
          "updated_at"=>"2021-02-12T12:02:55.467-05:00",
          "state"=>"published",
          "publish_at"=>nil,
          "authorized_page_ids"=>[],
          "image_url"=>nil,
          "social_posts"=>[]
        },
        {
          "id"=>2,
          "body"=>"Testing from Production",
          "created_at"=>"2021-02-12T13:19:38.759-05:00",
          "updated_at"=>"2021-02-12T13:19:51.501-05:00",
          "state"=>"published",
          "publish_at"=>nil,
          "authorized_page_ids"=>[2],
          "image_url"=>nil,
          "social_posts"=>[
            {
              "id"=>2
            }
          ]
        },
        {
          "id"=>3,
          "body"=>"\"I want to break free\"",
          "created_at"=>"2021-02-12T13:20:56.445-05:00",
          "updated_at"=>"2021-02-12T13:21:26.134-05:00",
          "state"=>"published",
          "publish_at"=>nil,
          "authorized_page_ids"=>[3],
          "image_url"=>"https://onepost-aws-assets.s3.amazonaws.com/...",
          "social_posts"=>[{"id"=>3}]
        }
      ]
    }
  end

  def example_post_data
    {
      "id"=>1,
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
