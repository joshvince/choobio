defmodule ChoobioWeb.LineView do
  use ChoobioWeb, :view
  alias ChoobioWeb.LineView

  def render("show.json", %{line: line}) do
    %{data: render_one(line, LineView, "line.json")}
  end

  def render("line.json", %{line: line}) do
    %{id: line.id, name: line.name}
  end

end