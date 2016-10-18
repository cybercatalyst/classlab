defmodule Classlab.Classroom.DashboardViewTest do
  alias Classlab.Classroom.DashboardView
  use Classlab.ConnCase, async: true

  describe "#format_rating" do
    test "returns an empty string if no number is given" do
      assert DashboardView.format_rating(nil) == ""
    end

    test "returns a rounded number as string" do
      assert DashboardView.format_rating(Decimal.new(2.55555)) == "2.56"
    end
  end
end
