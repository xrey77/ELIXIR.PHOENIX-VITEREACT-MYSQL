defmodule ElixirMysql.Token do
  use Joken.Config

  # Optionally, define how default claims are generated/validated here
  @impl true
  def token_config do
    default_claims()
  end
end
