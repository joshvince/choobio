defmodule Choobio.Tfl.Arrival do
	@moduledoc """
	Defines a struct that assists the process of turning JSON payloads (retrieved
	from the TFL API calls) to Elixir code.
	"""
	defstruct [	:currentLocation, :destinationName, :destinationNaptanId, :direction,
							:expectedArrival, :vehicleId, :lineId, :naptanId, :platformName,
							:stationName,	:timeToStation, :towards]


end
