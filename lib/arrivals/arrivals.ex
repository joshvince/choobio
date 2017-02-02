defmodule Commuter.Arrivals do
  @tooting "940GZZLUTBC"
  @lines "northern"

  def start(station_id, line_id) do
    Task.start_link(fn -> listen(station_id, line_id) end)
  end

  defp get_arrivals(station_id, line_id) do

  end

  defp call_tfl(station_id, line_id) do
    "https://api.tfl.gov.uk/Line/#{line_id}/Arrivals?stopPointId=#{station_id}"
    |> HTTPpotion.get
  end

  defp parse_response(response) do
    
  end

  defp listen(station, line) do
    # receive do
    #   {:get, line_id, caller} ->
    #     send caller, Map.get(map, line_id)
    #     listen(map)
    #   {:put, line_id, times} ->
    #     Map.put(map, line_id, times)
    #     |> listen
    # end
  end

end
