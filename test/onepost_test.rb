require "test_helper"

class OnepostTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Onepost::VERSION
  end
end
