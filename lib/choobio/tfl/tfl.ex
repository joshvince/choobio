defmodule Choobio.Tfl do
  @moduledoc """
  Responsible for making calls out to the TFL API.
  """

#####
  # Application Setup - these are called only when running seeds.
#####

  @tfl_all_stations "https://api.tfl.gov.uk/StopPoint/Type/NaptanMetroStation"

  def create_station_list do
    retrieve_all_stations()
    |> Enum.filter( &is_tube_station?(&1) )
    |> Enum.map( &create_station_params(&1) )
  end

  defp retrieve_all_stations(url \\ @tfl_all_stations) do
    IO.puts "Calling TFL for the list of stations..."
    call_tfl(url, [timeout: 50_000])
    |> handle_response
    |> try_decode
  end

  # I am not letting this crash like I should, because this call MUST
  # succeed for the appliation server to start.
  defp handle_response(%HTTPotion.Response{body: body}) do
    body
  end
  defp handle_response(_anything_else), do: retrieve_all_stations()

  defp try_decode(resp) do
    case Poison.decode(resp) do
      {:ok, list} ->
        list
      true ->
        retrieve_all_stations()
    end
  end

  defp is_tube_station?(map) do
    modes = map["modes"]
    Enum.member? modes, "tube"
  end

  defp create_station_params(map) do
    %{
      name: remove_suffix(map["commonName"]),
      naptanId: map["naptanId"],
      lines: find_lines(map)
    }
  end

  defp find_lines(map) do
    map["lineModeGroups"]
    |> Enum.find(fn map -> map["modeName"] == "tube" end)
    |> get_line_id_list
  end

  defp get_line_id_list(map), do: map["lineIdentifier"]

  defp remove_suffix(name_string) do
    String.replace(name_string, ~r/ Underground Station/, "")
  end


#####
  # CALL FOR ALL ARRIVALS ON THE NETWORK
#####

  @all_trains "https://api.tfl.gov.uk/Mode/tube/Arrivals?count=5"
  def get_all_arrivals(url \\ "https://api.tfl.gov.uk/line/northern/arrivals") do
    call_tfl(url)
    |> take_body
    |> Poison.decode!(as: [%Choobio.Tfl.Arrival{}])
  end


#####
  # Helper functions:
#####

  @doc """
  All-purpose call to TFL using an HTTP client.

  Appends the app key and app ID to the url before making a get request to `url`.
  """
  def call_tfl(url, opts \\ []) do
    url
    |> add_credentials
    |> HTTPotion.get(opts)
  end

  #TODO: this should take the api key and api id from mix.env
  defp add_credentials(url) do
    url
  end

	defp take_body(%HTTPotion.Response{body: body}), do: body

end
