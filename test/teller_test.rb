require "test_helper"

class TellerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Teller::VERSION
  end
end
