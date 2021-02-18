require "test_helper"

class OnepostAuthorizedPageTest < Minitest::Test
  def setup
    @client = Onepost::Client.new(
      rapid_api_key: "12345",
      secret_key: "67890"
    )
  end

  def test_can_fetch_all_authorized_pages
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/authorized_pages?secret_key=67890")
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
      ).to_return(status: 200, body: example_authorized_pages_data.to_json, headers: {})

    data = @client.get_authorized_pages
    assert_equal 3, data["collection"].count
  end

  def test_can_fetch_an_authorized_page
    stub_request(:get, "https://onepost1.p.rapidapi.com/api/v1/authorized_pages/2?secret_key=67890")
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
      ).to_return(status: 200, body: example_authorized_page_data.to_json, headers: {})

    data = @client.get_authorized_page(2)
    assert_equal 2, data["id"]
  end

  private

  def example_authorized_pages_data
    {
      "current_page"=>1,
      "per_page"=>30,
      "total_entries"=>3,
      "collection"=>[
        {
          "id"=>2,
          "authorization_id"=>2,
          "name"=>"Opendate",
          "service_id"=>"115546706803453",
          "type"=>"AuthorizedPages::Facebook",
          "info"=>{},
          "access_token"=>"EAA...",
          "instagram_business_account"=>{"id"=>"17841421827949046"},
          "created_at"=>"2021-02-12T13:18:48.236-05:00",
          "updated_at"=>"2021-02-12T13:18:48.236-05:00"
        },
        {
          "id"=>3,
          "authorization_id"=>2,
          "name"=>"opendate",
          "service_id"=>"17841421827949046",
          "type"=>"AuthorizedPages::Instagram",
          "info"=>{},
          "created_at"=>"2021-02-12T13:18:48.625-05:00",
          "updated_at"=>"2021-02-12T13:18:48.625-05:00"
        },
        {
          "id"=>5,
          "authorization_id"=>4,
          "name"=>"1bertlol",
          "service_id"=>"81534513",
          "type"=>"AuthorizedPages::Twitter",
          "info"=>{}
        }
      ]
    }
  end

  def example_authorized_page_data
    {
      "id"=>2,
      "authorization_id"=>2,
      "name"=>"Opendate",
      "service_id"=>"115546706803453",
      "type"=>"AuthorizedPages::Facebook",
      "info"=>{},
      "created_at"=>"2021-02-12T13:18:48.236-05:00",
      "updated_at"=>"2021-02-12T13:18:48.236-05:00"
    }
  end
end
