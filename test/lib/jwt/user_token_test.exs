defmodule Classlab.JWT.UserTokenTest do
  alias Classlab.JWT.UserToken
  use Classlab.ConnCase

  describe "#encode" do
    test "return a valid jwt" do
      assert UserToken.encode(%UserToken{user_id: 1}) ==
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxfQ.Fl_dAGOvt8rPcvFlqoAI7z5_WUqGU9ATv9ySKi029kI"
    end
  end

  describe "#decode" do
    @valid_token "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxfQ.Fl_dAGOvt8rPcvFlqoAI7z5_WUqGU9ATv9ySKi029kI"
    test "return a map from a VALID jwt" do
      assert UserToken.decode(@valid_token) == %UserToken{user_id: 1}
    end
  end
end
