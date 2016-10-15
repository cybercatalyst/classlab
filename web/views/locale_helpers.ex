defmodule Classlab.LocaleHelpers do
  @moduledoc """
  Locale helpers. Helper functions for date and time formatting in templates.
  """
  alias Calendar.Strftime

  def l(%Date{} = date, [format: format]) do
    Strftime.strftime!(date, format, :de)
  end

  def l(%DateTime{} = date, [format: format]) do
    date
    # |> Calendar.DateTime.shift_zone!("Europe/Berlin")
    |> Strftime.strftime!(format, :de)
  end

  def l(%Date{} = date) do
    Strftime.strftime!(date, "%d.%m.%Y")
  end

  def l(%DateTime{} = date) do
    date
    # |> Calendar.DateTime.shift_zone!("Europe/Berlin")
    |> Strftime.strftime!("%d.%m.%Y %M:%H")
  end
end
