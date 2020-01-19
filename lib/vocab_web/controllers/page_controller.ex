defmodule VocabWeb.PageController do
  use VocabWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
