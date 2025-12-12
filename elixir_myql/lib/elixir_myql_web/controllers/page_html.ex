defmodule ElixirMyqlWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use ElixirMyqlWeb, :html

  # embed_templates "page_html/*"
  embed_templates "../templates/home/*"

end
