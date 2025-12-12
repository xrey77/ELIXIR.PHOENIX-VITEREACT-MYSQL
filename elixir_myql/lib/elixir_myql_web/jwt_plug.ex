defmodule ElixirMyqlWeb.Plug.Authenticate do
  import Plug.Conn
  alias ElixirMyql.Token

  def init(opts), do: opts

  def call(conn, _opts) do

    case get_req_header(conn, "authorization") do
      [bearer] ->
        token = String.replace(bearer, "Bearer ", "")
        verify_token(conn, token)

      [] ->
        halt(send_resp(conn, 401, "{\"message\": \"Unauthorized Access.\"}"))
    end
  end

  defp verify_token(conn, token) do
    case Token.verify_and_validate(token) do
      {:ok, claims} ->
        user_id = claims["user_id"]
        assign(conn, :current_user_id, user_id)

      {:error, reason} ->
        IO.inspect(reason, only: :error)
        halt(send_resp(conn, 401, "{\"message\": \"Invalid or expired token\"}"))
    end
  end
end
