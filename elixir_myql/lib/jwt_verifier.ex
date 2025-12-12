defmodule ElixirMyql.Token do
  use Joken.Config

  @impl Joken.Config
  def token_config do
    default_claims()
  end
end
