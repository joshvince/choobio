defmodule Choobio.TflTest do
	use ExUnit.Case
	alias Choobio.Tfl
	@tfl_api Application.get_env(:choobio, :tfl_api)

	setup do
		response = @tfl_api.get_all_arrivals("northern")
		{:ok, %{api_response: response}}
	end

	test "returns the API call as Arrival structs", %{api_response: resp} do
		Enum.each(resp, fn str -> str.__struct__ == Tfl.Arrival end)
	end
end
