require "test_helper"

class OnepostImageTest < Minitest::Test
  def setup
    @client = Onepost::Client.new(
      rapid_api_key: "12345",
      secret_key: "67890"
    )
  end

  def test_can_fetch_all_images
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/images?secret_key=67890")
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
      .to_return(status: 200, body: example_images_data.to_json, headers: {})

    data = @client.get_images
    assert_equal 1, data["collection"].count
  end

  def test_can_fetch_one_image
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/images/28?secret_key=67890")
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
      .to_return(status: 200, body: example_image_data.to_json, headers: {})

    data = @client.get_image(28)
    assert_equal 28, data["id"]
  end

  def test_can_create_a_new_image
    stub_request(:post, "https://onepost1.p.rapidapi.com/api/v1/images?secret_key=67890")
      .with(
        body: "{\"image\":{\"source\":\"API Test\",\"image_url\":\"https://images1.westword.com/imager/u/original/11685568/redrockseaster.jpg\"}}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
      })
      .to_return(status: 200, body: example_image_data.to_json, headers: {})

    data = @client.create_image(body: {
      image: {
        source: "API Test",
        image_url: "https://images1.westword.com/imager/u/original/11685568/redrockseaster.jpg"
      }
    })
    assert_equal 28, data["id"]
  end

  def test_can_create_a_new_post_with_image_upload
    skip "WebMock does not support matching body for multipart/form-data requests yet :("

    stub_request(:post, "https://onepost1.p.rapidapi.com/api/v1/images?secret_key=67890")
    .with(
      body: "image%5Bsource%5D=API%20Test&image%5Bimage%5D=%2FUsers%2Fadam%2FDeveloper%2Fonepost%2Fonepost-gem%2Ftest%2Ffiles%2Fredrocks.jpg",
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'multipart/form-data',
        'User-Agent'=>'Ruby',
        'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
        'X-Rapidapi-Key'=>'12345'
    })
    .to_return(status: 200, body: example_image_data.to_json, headers: {})

    data = @client.create_image(
      headers: {
        "Content-Type" => "multipart/form-data"
      },
      body: {
        image: {
          source: "API Test",
          image: File.join(Dir.pwd, "test/files/redrocks.jpg")
        }
      }
    )
    assert_equal 28, data["id"]
  end

  def test_can_update_an_image
    stub_request(:put, "https://onepost1.p.rapidapi.com/api/v1/images/28?secret_key=67890")
      .with(
        body: "{\"image\":{\"source\":\"Updated Source\"}}",
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type'=>'application/json',
          'User-Agent'=>'Ruby',
          'X-Rapidapi-Host'=>'onepost1.p.rapidapi.com',
          'X-Rapidapi-Key'=>'12345'
      })
      .to_return(status: 200, body: example_image_data.to_json, headers: {})

    data = @client.update_image(28, body: {
      image: {
        source: "Updated Source"
      }
    })
    assert_equal 28, data["id"]
  end

  def test_can_delete_an_image
    stub_request(:delete, "https://onepost1.p.rapidapi.com/api/v1/images/28?secret_key=67890")
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
      .to_return(status: 200, body: example_image_data.to_json, headers: {})

    data = @client.delete_image(28)
    assert_equal 28, data["id"]
  end

  private

  def example_images_data
    {
      "current_page"=>1,
      "per_page"=>30,
      "total_entries"=>1,
      "collection"=>[
        {
          "id"=>28,
          "created_at"=>"2021-03-10T13:01:19.775-05:00",
          "updated_at"=>"2021-03-10T13:01:19.791-05:00",
          "source"=>"API Test",
          "image_url"=>"https://onepost-aws-assets.s3.amazonaws.com/zzm7qez...",
          "thumb_url"=>"https://onepost-aws-assets.s3.amazonaws.com/variant...",
          "filename"=>"redrockseaster.jpg",
          "file_size"=>"501 KB"
        }
      ]
    }
  end

  def example_image_data
    {
      "id"=>28,
      "created_at"=>"2021-03-10T13:01:19.775-05:00",
      "updated_at"=>"2021-03-10T13:01:19.791-05:00",
      "source"=>"API Test",
      "image_url"=>"https://onepost-aws-assets.s3.amazonaws.com/zzm7qezxwrsf4hard0klp6h4jfr3...",
      "thumb_url"=>"https://onepost-aws-assets.s3.amazonaws.com/variants/zzm7qezxwrsf4hard0k...",
      "filename"=>"redrockseaster.jpg",
      "file_size"=>"501 KB"
    }
  end
end
