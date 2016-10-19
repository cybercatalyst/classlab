defmodule Classlab.Utils.StringExtensionsTest do
  alias Classlab.Utils.StringExtensions
  use Classlab.ConnCase, async: true

  describe "#parameterize" do
    test "converts accented chars" do
      assert StringExtensions.parameterize("märchen") == "maerchen"
    end

    test "turns unwanted chars into the separator" do
      assert StringExtensions.parameterize("abc?abc") == "abc-abc"
    end

    test "removes more than one separator in a row" do
      assert StringExtensions.parameterize("abc--abc") == "abc-abc"
    end

    test "removes leading separator" do
      assert StringExtensions.parameterize("-abc") == "abc"
    end

    test "removes trailing separator" do
      assert StringExtensions.parameterize("abc-") == "abc"
    end

    test "downcases the result" do
      assert StringExtensions.parameterize("Märchen schreiben?") == "maerchen-schreiben"
    end
  end

  describe "#transliterate" do
    test "coverts german umlaute to ascii chars" do
      assert StringExtensions.transliterate("Märchen") == "Maerchen"
      assert StringExtensions.transliterate("Füße") == "Fuesse"
    end
  end
end