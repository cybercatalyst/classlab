defmodule Classlab.JWT.UserIdToken do
  @moduledoc """
  Is needed for sign user_id for user session
  """
  defstruct user_id: nil

  def encode(%__MODULE__{} = params) do
    params
    |> Joken.token()
    |> Joken.with_signer(Joken.hs256(Application.get_env(:classlab, :jwt_secret)))
    |> Joken.sign()
    |> Joken.get_compact()
  end

  def decode(nil) do nil end
  def decode(token) when is_binary(token) do
    result =
      token
      |> Joken.token()
      |> Joken.with_signer(Joken.hs256(Application.get_env(:classlab, :jwt_secret)))
      |> Joken.verify()

    case result do
      %Joken.Token{claims: claims, error: nil} -> claims
      %Joken.Token{error: _}                   -> nil
    end
  end
end
