defmodule Classlab.ErrorRescue do
  @moduledoc """
  A general error handler for controllers. Usually used for catching ecto errors.

  Usage example:
  use Classlab.ErrorRescue, from: Ecto.NoResultsError, redirect_to: &post_path(&1, :index)
  """

  defmacro __using__(error) do
    quote  do
      alias Plug.Conn.WrapperError
      use Plug.ErrorHandler

      @doc false
      def handle_errors(conn, %{kind: kind, reason: reason, stack: _stack}) do
        if reason.__struct__ == unquote(error[:from]) do
          redirect_to_path = unquote(error[:redirect_to]).(conn)

          conn
          |> put_status(301)
          |> put_flash(:error, "Ressource not found")
          |> redirect(to: redirect_to_path)
          |> halt()
        else
          WrapperError.reraise(conn, kind, reason)
        end
      end

      defoverridable [handle_errors: 2]
    end
  end
end
