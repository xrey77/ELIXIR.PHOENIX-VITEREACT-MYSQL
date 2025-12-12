defmodule ElixirMyqlWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :elixir_myql

  @session_options [
    store: :cookie,
    key: "_elixir_myql_key",
    signing_salt: "CtPcb4QT",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]],
    longpoll: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :elixir_myql,
    gzip: false,
    only: ~w(assets fonts images react users products qrcodes favicon.ico robots.txt)

    if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :elixir_myql
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug CORSPlug, origin: ["http://localhost:5173"]
  plug ElixirMyqlWeb.Router
end
