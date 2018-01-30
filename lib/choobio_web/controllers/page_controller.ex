defmodule ChoobioWeb.PageController do
  use ChoobioWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
