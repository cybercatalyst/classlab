defmodule Classlab.Utils.SluggerTest do
  alias Classlab.Utils.Slugger
  use Classlab.ConnCase, async: true

  describe "#parameterize" do
    test "converts accented chars" do
      assert Slugger.parameterize("märchen") == "maerchen"
    end

    test "turns unwanted chars into the separator" do
      assert Slugger.parameterize("abc?abc") == "abc-abc"
    end

    test "removes more than one separator in a row" do
      assert Slugger.parameterize("abc--abc") == "abc-abc"
    end

    test "removes leading separator" do
      assert Slugger.parameterize("-abc") == "abc"
    end

    test "removes trailing separator" do
      assert Slugger.parameterize("abc-") == "abc"
    end

    test "downcases the result" do
      assert Slugger.parameterize("Märchen schreiben?") == "maerchen-schreiben"
    end
  end

  describe "#transliterate" do
    test "coverts german umlaute to ascii chars" do
      assert Slugger.transliterate("Märchen") == "Maerchen"
      assert Slugger.transliterate("Füße") == "Fuesse"
    end
  end
end