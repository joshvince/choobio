defmodule Commuter.Tfl.Mock do
  @moduledoc """
  Provides a mock TFL server to allow tests to get quick data without calling
  the real life TFL api.
  """
  @behaviour Commuter.Tfl

  @doc """
  A smoke screen - this will always return true because we don't need to
  test the failure of a mock api call... Let it crash!!
  """
  def successful_response?(_response), do: true

  @doc """
  This doesn't do anything. Just a smoke screen.
  """
  def take_body(list), do: list

  @doc """
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
        "commonName" => "Waterloo", "modes" => ["tube", "bus"],
        "naptanId" => "940GZZLUWLO",
        "lineModeGroups" => [%{"modeName" => "tube",
                              "lineIdentifier" => [ "northern", "jubilee",
                                                    "bakerloo", "waterloo-city"]},
                            %{"modeName" => "bus",
                              "lineIdentifier" => ["10"]}]
      },
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

  @doc """
  Returns a JSON string full of train objects as if it was from TFL.
  """
  def line_arrivals("940GZZLUTBC", "northern") do
    [%{"$type" => "Tfl.Api.Presentation.Entities.Prediction, Tfl.Api.Presentation.Entities",
      "bearing" => "", "currentLocation" => "Between Moorgate and Bank",
      "destinationName" => "Morden Underground Station",
      "destinationNaptanId" => "940GZZLUMDN", "direction" => "inbound",
      "expectedArrival" => "2017-02-11T09:34:50Z", "id" => "-2042375039",
      "lineId" => "northern", "lineName" => "Northern", "modeName" => "tube",
      "naptanId" => "940GZZLUTBC", "operationType" => 1,
      "platformName" => "Southbound - Platform 2",
      "stationName" => "Tooting Bec Underground Station",
      "timeToLive" => "2017-02-11T09:34:50Z", "timeToStation" => 1367,
      "timestamp" => "2017-02-11T09:12:03Z",
      "timing" =>
        %{"$type" => "Tfl.Api.Presentation.Entities.PredictionTiming, Tfl.Api.Presentation.Entities",
          "countdownServerAdjustment" => "00:00:00",
          "insert" => "0001-01-01T00:00:00", "read" => "2017-02-11T09:12:02.591Z",
          "received" => "0001-01-01T00:00:00", "sent" => "2017-02-11T09:12:03Z",
          "source" => "0001-01-01T00:00:00"}, "towards" => "Morden via Bank",
          "vehicleId" => "262"},
    %{"$type" => "Tfl.Api.Presentation.Entities.Prediction, Tfl.Api.Presentation.Entities",
    "bearing" => "", "currentLocation" => "Approaching Tooting Bec",
    "destinationName" => "High Barnet Underground Station",
    "destinationNaptanId" => "940GZZLUHBT", "direction" => "outbound",
    "expectedArrival" => "2017-02-11T09:12:20Z", "id" => "-35420651",
    "lineId" => "northern", "lineName" => "Northern", "modeName" => "tube",
    "naptanId" => "940GZZLUTBC", "operationType" => 1,
    "platformName" => "Northbound - Platform 1",
    "stationName" => "Tooting Bec Underground Station",
    "timeToLive" => "2017-02-11T09:12:20Z", "timeToStation" => 17,
    "timestamp" => "2017-02-11T09:12:03Z",
    "timing" => %{"$type" => "Tfl.Api.Presentation.Entities.PredictionTiming, Tfl.Api.Presentation.Entities",
      "countdownServerAdjustment" => "00:00:00",
      "insert" => "0001-01-01T00:00:00", "read" => "2017-02-11T09:12:02.528Z",
      "received" => "0001-01-01T00:00:00", "sent" => "2017-02-11T09:12:03Z",
      "source" => "0001-01-01T00:00:00"}, "towards" => "High Barnet via Bank",
      "vehicleId" => "246"},
    %{"$type" => "Tfl.Api.Presentation.Entities.Prediction, Tfl.Api.Presentation.Entities",
    "bearing" => "", "currentLocation" => "At Elephant and Castle Platform 2",
    "destinationName" => "Morden Underground Station",
    "destinationNaptanId" => "940GZZLUMDN", "direction" => "inbound",
    "expectedArrival" => "2017-02-11T09:27:50Z", "id" => "991083851",
    "lineId" => "northern", "lineName" => "Northern", "modeName" => "tube",
    "naptanId" => "940GZZLUTBC", "operationType" => 1,
    "platformName" => "Southbound - Platform 2",
    "stationName" => "Tooting Bec Underground Station",
    "timeToLive" => "2017-02-11T09:27:50Z", "timeToStation" => 947,
    "timestamp" => "2017-02-11T09:12:03Z",
    "timing" => %{"$type" => "Tfl.Api.Presentation.Entities.PredictionTiming, Tfl.Api.Presentation.Entities",
      "countdownServerAdjustment" => "00:00:00",
      "insert" => "0001-01-01T00:00:00", "read" => "2017-02-11T09:12:02.575Z",
      "received" => "0001-01-01T00:00:00", "sent" => "2017-02-11T09:12:03Z",
      "source" => "0001-01-01T00:00:00"}, "towards" => "Morden via Bank",
      "vehicleId" => "244"},
    %{"$type" => "Tfl.Api.Presentation.Entities.Prediction, Tfl.Api.Presentation.Entities",
    "bearing" => "",
    "currentLocation" => "Between Colliers Wood and Tooting Broadway",
    "destinationName" => "Edgware Underground Station",
    "destinationNaptanId" => "940GZZLUEGW", "direction" => "outbound",
    "expectedArrival" => "2017-02-11T09:14:50Z", "id" => "-2040605567",
    "lineId" => "northern", "lineName" => "Northern", "modeName" => "tube",
    "naptanId" => "940GZZLUTBC", "operationType" => 1,
    "platformName" => "Northbound - Platform 1",
    "stationName" => "Tooting Bec Underground Station",
    "timeToLive" => "2017-02-11T09:14:50Z", "timeToStation" => 167,
    "timestamp" => "2017-02-11T09:12:03Z",
    "timing" => %{"$type" => "Tfl.Api.Presentation.Entities.PredictionTiming, Tfl.Api.Presentation.Entities",
      "countdownServerAdjustment" => "00:00:00",
      "insert" => "0001-01-01T00:00:00", "read" => "2017-02-11T09:12:02.528Z",
      "received" => "0001-01-01T00:00:00", "sent" => "2017-02-11T09:12:03Z",
      "source" => "0001-01-01T00:00:00"}, "towards" => "Edgware via Bank",
      "vehicleId" => "212"}]
      |> Poison.encode!
  end

  @doc """
  Converts timestamp strings to DateTime objects.
  """
  def to_datetime(timestamp) do
    timestamp
    |> remove_ms
    |> add_timezone
    |> Timex.parse!("{ISO:Extended}")
  end

  defp remove_ms(timestamp) do
    case String.split(timestamp, ".") do
      [time, _ms] ->
        time
      [_time] ->
        timestamp
    end
  end

  defp add_timezone(string), do: "#{string}Z"

end
