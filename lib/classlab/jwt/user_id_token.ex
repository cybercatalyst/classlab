defmodule Classlab.JWT.UserIdToken do
  @moduledoc """
  Is needed for sign user_id for user session
  """
  alias Classlab.{Repo, Session}
  defstruct user_id: nil

  def encode(%__MODULE__{} = params) do
    jwt_session = Repo.insert!(Session.changeset(%Session{}))

    params
    |> Joken.token()
    |> Joken.with_exp(Joken.current_time + 120)
    |> Joken.with_jti(jwt_session.jti)
    |> Joken.with_signer(Joken.hs256(Application.get_env(:classlab, :jwt_secret)))
    |> Joken.sign()
    |> Joken.get_compact()
  end

  def decode(token) when is_binary(token) do
    result =
      token
      |> Joken.token()
      |> Joken.with_validation("exp", &(&1 > Joken.current_time))
      |> Joken.with_validation("jti", &(Session.find_and_delete(&1)))
      |> Joken.with_signer(Joken.hs256(Application.get_env(:classlab, :jwt_secret)))
      |> Joken.verify()

    case result do
      %Joken.Token{claims: claims, error: nil} -> claims
      %Joken.Token{error: _}                   -> nil
    end
  end
end
