defmodule ChoobioWeb.ArrivalsView do
  use ChoobioWeb, :view
  alias ChoobioWeb.ArrivalsView

  def render("show.json", %{arrivals: arrivals}) do
    %{data: render_one(arrivals, ArrivalsView, "arrivals.json")}
  end

  def render("arrivals.json", %{arrivals: arrivals}) do
    %{arrivals: arrivals}
  end
end