defmodule ChoobioWeb.StationView do
  use ChoobioWeb, :view
  alias ChoobioWeb.{StationView, LineView}

  def render("index.json", %{stations: stations}) do
    %{data: render_many(stations, StationView, "station.json")}
  end

  def render("show.json", %{station: station}) do
    %{data: render_one(station, StationView, "station_with_lines.json")}
  end

  def render("station.json", %{station: station}) do
    %{id: station.naptan_id, name: station.name}
  end

  def render("station_with_lines.json", %{station: station}) do
    lines = Enum.map(station.lines, &LineView.render("line.json", %{line: &1}) )
    %{id: station.naptan_id,
      name: station.name,
      lines: lines}
  end
end
