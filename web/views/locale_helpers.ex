defmodule Classlab.LocaleHelpers do

  def l(%Date{} = date, [format: format]) do
    Calendar.Strftime.strftime!(date, format, :de)
  end

  def l(%DateTime{} = date, [format: format]) do
    date
    # |> Calendar.DateTime.shift_zone!("Europe/Berlin")
    |> Calendar.Strftime.strftime!(format, :de)
  end

  def l(%Date{} = date) do
    Calendar.Strftime.strftime!(date, "%d.%m.%Y")
  end

  def l(%DateTime{} = date) do
    date
    # |> Calendar.DateTime.shift_zone!("Europe/Berlin")
    |> Calendar.Strftime.strftime!("%d.%m.%Y %M:%H")
  end
end
