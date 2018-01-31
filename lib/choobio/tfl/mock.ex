defmodule Choobio.Tfl.Mock do
  @moduledoc """
  Mocks interactions with the TFL API for testing and local development.
  """
  @behaviour Choobio.Tfl

  @doc """
  Retrieve all stations from the Mock TFL API.
  
  Returns four stations:
  - Clapham Junction
  - Waterloo
  - Tooting Bec
  - Victoria

  Returns a list of objects.
  """
  def retrieve_all_stations(_url \\ "fake") do
    IO.puts "Using Mock TFL to get station list..."
    [
      %{
        "commonName" => "Tooting Bec", "modes" => ["tube"],
        "naptanId" => "940GZZLUTBC",
        "lineModeGroups" => [%{"modeName" => "tube",
                              "lineIdentifier" => [ "northern"]},
                            %{"modeName" => "bus",
                              "lineIdentifier" => ["130"]}]
      },
      %{
        "commonName" => "Victoria", "modes" => ["tube", "bus", "rail"],
        "naptanId" => "940GZZLUVIC",
        "lineModeGroups" => [%{"modeName" => "tube",
                              "lineIdentifier" => [ "circle", "district",
                                                    "victoria"]},
                            %{"modeName" => "bus",
                              "lineIdentifier" => ["N130"]}]
      },
      %{
        "commonName" => "Clapham Junction", "modes" => ["rail", "bus"],
        "naptanId" => "940GZZLUCLA",
        "lineModeGroups" => [%{"modeName" => "bus",
                              "lineIdentifier" => [ "N133", "100"]}]
      }
    ]
  end

  def retrieve_all_lines(_url \\ "fake") do
    IO.puts "Using Mock TFL to get line list..."
    [
      %{"id" => "victoria", "modeName" => "tube", "name" => "Victoria"},
      %{"id" => "northern", "modeName" => "tube", "name" => "Northern"},
      %{"id" => "circle", "modeName" => "tube", "name" => "Circle"},
      %{"id" => "district", "modeName" => "tube", "name" => "District"}
    ]
  end
end