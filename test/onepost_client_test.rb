require "test_helper"

class OnepostClientTest < Minitest::Test
  def setup
    @rapid_api_key = "12345"
    @secret_key = "67890"
  end

  def test_a_client_can_be_initialized
    @client = Onepost::Client.new(
      rapid_api_key: @rapid_api_key,
      secret_key: @secret_key
    )

    assert_equal @rapid_api_key, @client.rapid_api_key
    assert_equal @secret_key, @client.secret_key
  end

  def test_when_no_rapid_api_key_is_provide
    assert_raises KeyError do
      @client = Onepost::Client.new(
        secret_key: @secret_key
      )
    end
  end

  def test_when_no_secret_key_is_provided
    assert_raises KeyError do
      @client = Onepost::Client.new(
        rapid_api_key: @rapid_api_key
      )
    end
  end
end
