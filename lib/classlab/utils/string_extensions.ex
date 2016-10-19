defmodule Classlab.Utils.StringExtensions do
  @moduledoc"""
  A collection of utilities for string manipulation.
  """

  @doc """
  Replaces special characters in a string so that it may be used as part of a ‘pretty’ URL.
  """
  def parameterize(str, sep \\ "-") do
    str
    |> transliterate()
    |> String.downcase
    |> String.replace(~r/[^a-z0-9\-_]+/, sep)
    |> String.replace(~r/#{sep}{2,}/, sep)
    |> String.trim_leading(sep)
    |> String.trim_trailing(sep)
  end

  @doc """
  Replaces non-ASCII characters with an ASCII approximation. Only german supported by now.
  """
  def transliterate(str) do
    str
    |> String.replace("Ü", "Ue")
    |> String.replace("ü", "ue")
    |> String.replace("Ä", "Ae")
    |> String.replace("ä", "ae")
    |> String.replace("Ö", "Oe")
    |> String.replace("ö", "oe")
    |> String.replace("ß", "ss")
  end
end