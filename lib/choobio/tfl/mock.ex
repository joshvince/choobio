defmodule Choobio.Tfl.Mock do
	@moduledoc """
	Provides a fake version of TFL API payloads to allow for testing without
	the dependency of the real TFL API.

	Always use the northern line for tests.
	"""

	#####
	  # CALL FOR ALL ARRIVALS ON THE NETWORK
	#####

	@arrivals_response [
	 %{"$type" => "Tfl.Api.Presentation.Entities.Prediction, Tfl.Api.Presentation.Entities",
   "bearing" => "", "currentLocation" => "At Bank Platform 4",
   "destinationName" => "Edgware Underground Station",
   "destinationNaptanId" => "940GZZLUEGW", "direction" => "outbound",
   "expectedArrival" => "2017-03-17T08:29:18Z", "id" => "-774824354",
   "lineId" => "northern", "lineName" => "Northern", "modeName" => "tube",
   "naptanId" => "940GZZLUEUS", "operationType" => 1,
   "platformName" => "Northbound - Platform 3",
   "stationName" => "Euston Underground Station",
   "timeToLive" => "2017-03-17T08:29:18Z", "timeToStation" => 580,
   "timestamp" => "2017-03-17T08:19:38Z",
   "timing" => %{"$type" => "Tfl.Api.Presentation.Entities.PredictionTiming, Tfl.Api.Presentation.Entities",
     "countdownServerAdjustment" => "00:00:00",
     "insert" => "0001-01-01T00:00:00", "read" => "2017-03-17T08:19:26.804Z",
     "received" => "0001-01-01T00:00:00", "sent" => "2017-03-17T08:19:38Z",
     "source" => "0001-01-01T00:00:00"}, "towards" => "Edgware via Bank",
   "vehicleId" => "022"},
 %{"$type" => "Tfl.Api.Presentation.Entities.Prediction, Tfl.Api.Presentation.Entities",
   "bearing" => "", "currentLocation" => "At Leicester Square Platform 4",
   "destinationName" => "High Barnet Underground Station",
   "destinationNaptanId" => "940GZZLUHBT", "direction" => "outbound",
   "expectedArrival" => "2017-03-17T08:41:19Z", "id" => "-845757467",
   "lineId" => "northern", "lineName" => "Northern", "modeName" => "tube",
   "naptanId" => "940GZZLUFYC", "operationType" => 1,
   "platformName" => "Northbound - Platform 2",
   "stationName" => "Finchley Central Underground Station",
   "timeToLive" => "2017-03-17T08:41:19Z", "timeToStation" => 1301,
   "timestamp" => "2017-03-17T08:19:38Z",
   "timing" => %{"$type" => "Tfl.Api.Presentation.Entities.PredictionTiming, Tfl.Api.Presentation.Entities",
     "countdownServerAdjustment" => "00:00:00",
     "insert" => "0001-01-01T00:00:00", "read" => "2017-03-17T08:19:27.038Z",
     "received" => "0001-01-01T00:00:00", "sent" => "2017-03-17T08:19:38Z",
     "source" => "0001-01-01T00:00:00"}, "towards" => "High Barnet via CX",
   "vehicleId" => "210"},
 %{"$type" => "Tfl.Api.Presentation.Entities.Prediction, Tfl.Api.Presentation.Entities",
   "bearing" => "", "currentLocation" => "Departed Clapham Common",
   "destinationName" => "Morden Underground Station",
   "destinationNaptanId" => "940GZZLUMDN", "direction" => "inbound",
   "expectedArrival" => "2017-03-17T08:20:49Z", "id" => "1957467636",
   "lineId" => "northern", "lineName" => "Northern", "modeName" => "tube",
   "naptanId" => "940GZZLUCPS", "operationType" => 1,
   "platformName" => "Southbound - Platform 2",
   "stationName" => "Clapham South Underground Station",
   "timeToLive" => "2017-03-17T08:20:49Z", "timeToStation" => 71,
   "timestamp" => "2017-03-17T08:19:38Z",
   "timing" => %{"$type" => "Tfl.Api.Presentation.Entities.PredictionTiming, Tfl.Api.Presentation.Entities",
     "countdownServerAdjustment" => "00:00:00",
     "insert" => "0001-01-01T00:00:00", "read" => "2017-03-17T08:19:25.366Z",
     "received" => "0001-01-01T00:00:00", "sent" => "2017-03-17T08:19:38Z",
     "source" => "0001-01-01T00:00:00"}, "towards" => "Morden via CX",
   "vehicleId" => "101"},
 %{"$type" => "Tfl.Api.Presentation.Entities.Prediction, Tfl.Api.Presentation.Entities",
   "bearing" => "", "currentLocation" => "At Brent Cross Platform 2",
   "destinationName" => "Morden Underground Station",
   "destinationNaptanId" => "940GZZLUMDN", "direction" => "inbound",
   "expectedArrival" => "2017-03-17T08:21:49Z", "id" => "-1987262005",
   "lineId" => "northern", "lineName" => "Northern", "modeName" => "tube",
   "naptanId" => "940GZZLUGGN", "operationType" => 1,
   "platformName" => "Southbound - Platform 5",
   "stationName" => "Golders Green Underground Station",
   "timeToLive" => "2017-03-17T08:21:49Z", "timeToStation" => 131,
   "timestamp" => "2017-03-17T08:19:38Z",
   "timing" => %{"$type" => "Tfl.Api.Presentation.Entities.PredictionTiming, Tfl.Api.Presentation.Entities",
     "countdownServerAdjustment" => "00:00:00",
     "insert" => "0001-01-01T00:00:00", "read" => "2017-03-17T08:19:27.195Z",
     "received" => "0001-01-01T00:00:00", "sent" => "2017-03-17T08:19:38Z",
     "source" => "0001-01-01T00:00:00"}, "towards" => "Morden via Bank",
   "vehicleId" => "222"},
 %{"$type" => "Tfl.Api.Presentation.Entities.Prediction, Tfl.Api.Presentation.Entities",
   "bearing" => "", "currentLocation" => "Approaching Golders Green",
   "destinationName" => "Edgware Underground Station",
   "destinationNaptanId" => "940GZZLUEGW", "direction" => "outbound",
   "expectedArrival" => "2017-03-17T08:19:49Z", "id" => "1556680435",
   "lineId" => "northern", "lineName" => "Northern", "modeName" => "tube",
   "naptanId" => "940GZZLUGGN", "operationType" => 1,
   "platformName" => "Northbound - Platform 2",
   "stationName" => "Golders Green Underground Station",
   "timeToLive" => "2017-03-17T08:19:49Z", "timeToStation" => 11,
   "timestamp" => "2017-03-17T08:19:38Z",
   "timing" => %{"$type" => "Tfl.Api.Presentation.Entities.PredictionTiming, Tfl.Api.Presentation.Entities",
     "countdownServerAdjustment" => "00:00:00",
     "insert" => "0001-01-01T00:00:00", "read" => "2017-03-17T08:19:27.101Z",
     "received" => "0001-01-01T00:00:00", "sent" => "2017-03-17T08:19:38Z",
     "source" => "0001-01-01T00:00:00"}, "towards" => "Edgware via Bank",
   "vehicleId" => "127"}
 ]

	@doc """
	Returns some fake arrivals data - also, parses the stringed maps to Arrivals structs.
	In the "proper" Tfl module, this is done with the JSON decoder, but here we
	do it manually (using some code I took from Jose) to ensure the data is
	arriving in the same format, without needing the JSON decoder.
	"""
  def get_all_arrivals("northern") do
    @arrivals_response
		|> Enum.map( &to_struct(%Choobio.Tfl.Arrival{}, &1))
  end

	@doc """
	Converts a map with stringed keys into a struct. This function was pinched
	from Jose Valim ;)
	"""
	defp to_struct(kind, attrs) do
		struct = struct(kind)
		Enum.reduce Map.to_list(struct), struct, fn {k, _}, acc ->
			case Map.fetch(attrs, Atom.to_string(k)) do
				{:ok, v} -> %{acc | k => v}
				:error -> acc
			end
		end
	end

end
