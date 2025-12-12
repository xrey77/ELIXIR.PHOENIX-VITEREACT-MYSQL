defmodule ElixirMyql.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirMyqlWeb.Telemetry,
      ElixirMyql.Repo,
      {DNSCluster, query: Application.get_env(:elixir_myql, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirMyql.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ElixirMyql.Finch},
      # Start a worker by calling: ElixirMyql.Worker.start_link(arg)
      # {ElixirMyql.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirMyqlWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirMyql.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirMyqlWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
