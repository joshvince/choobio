# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Choobio.Repo.insert!(%Choobio.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Choobio.{Line, Station, Tfl}

# ADD ALL TUBE LINES

lines = [
  %{name: "Bakerloo", line_id: "bakerloo"}, %{name: "Central", line_id: "central"},
  %{name: "Circle", line_id: "circle"}, %{name: "District", line_id: "district"},
  %{name: "Hammersmith & City", line_id: "hammersmith-city"},
  %{name: "Jubilee", line_id: "jubilee"}, %{name: "Metropolitan", line_id: "metropolitan"},
  %{name: "Northern", line_id: "northern"}, %{name: "Piccadilly", line_id: "piccadilly"},
  %{name: "Victoria", line_id: "victoria"}, %{name: "Waterloo & City", line_id: "waterloo-city"}
]

Enum.each lines, &Line.create(&1)


# NEXT, ADD ALL THE STATIONS AND CREATE STATION <-> LINE ASSOCIATIONS

Tfl.create_station_list
|> Enum.each( &Station.create(&1) )
