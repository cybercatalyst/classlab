defmodule Classlab.CalendarHelpers do
  @moduledoc """
  Locale helpers. Helper functions for date and time formatting in templates.
  """
  alias Calendar.Strftime

  def l(%Date{} = date) do
    Strftime.strftime!(date, "%d.%m.%Y")
  end

  def l(%DateTime{} = date) do
    date
    # |> Calendar.DateTime.shift_zone!("Europe/Berlin")
    |> Strftime.strftime!("%d.%m.%Y %H:%M")
  end
end
