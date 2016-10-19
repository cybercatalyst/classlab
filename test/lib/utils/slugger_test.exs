defmodule Classlab.Utils.SluggerTest do
  alias Classlab.Utils.Slugger
  use Classlab.ConnCase, async: true

  defmodule ExampleSchema do
    use Ecto.Schema
    schema "" do
      field :slug, :string
      field :name, :string
    end
  end

  describe "#generate_slug" do
    test "basic slug generation" do
      changeset = cast(%ExampleSchema{}, %{name: "Hello world"}, [:name])
      changes = Slugger.generate_slug(changeset, :name).changes
      assert changes.slug == "hello-world"
    end

    test "with appended random numbers when attr is empty" do
      changeset = cast(%ExampleSchema{}, %{name: nil}, [:name])
      changes = Slugger.generate_slug(changeset, :name, random: 100000..999999).changes
      refute Map.get(changes, :slug)
    end

    test "with appended random numbers" do
      changeset = cast(%ExampleSchema{}, %{name: "Hello world"}, [:name])
      changes = Slugger.generate_slug(changeset, :name, random: 100000..999999).changes
      assert String.length(changes.slug) == 18
      assert Regex.match?(~r/-(\d{6,6})$/, changes.slug) # ends with 6 digits
    end
  end

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