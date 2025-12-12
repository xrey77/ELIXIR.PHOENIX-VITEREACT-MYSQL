defmodule ElixirMyql.Repo do
  use Ecto.Repo,
    otp_app: :elixir_myql,
    adapter: Ecto.Adapters.MyXQL
end
