defmodule ElixirMyqlWeb.PageController do
  use ElixirMyqlWeb, :controller

  def home(conn, _params) do
    # assigns = %{title: "BARCLAYS BANK"}
    # render(conn, "index.html", assigns)
    render(conn, "index.html", layout: false)
  end
end
