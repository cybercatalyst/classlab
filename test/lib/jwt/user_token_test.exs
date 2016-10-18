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
    test "returns a UserToken struct from a VALID jwt" do
      assert UserToken.decode(@valid_token) == %UserToken{user_id: 1}
    end

    @invalid_token "invalid_token"
    test "returns nil from an INVALID jwt" do
      assert UserToken.decode(@invalid_token) == nil
    end

    test "returns nil if no token at all" do
      assert UserToken.decode(nil) == nil
    end
  end
end
