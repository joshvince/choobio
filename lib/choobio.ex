defmodule Choobio do
  @moduledoc """
  Choobio keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Choobio.Station
  alias Choobio.Station.Platform

######
  #Stations
######

  @doc """
  List all the stations in the DB. 
  Supplying an atom representing a valid association will preload each
  record with the given association. 
  """
  def list_stations(), do: Station.list_stations()
  def list_stations(:lines), do: Station.list_stations(:lines)

  def get_station(id), do: Station.get_station!(id)
  def get_station(id, :lines), do: Station.get_station!(id, :lines)


######
  #Arrivals
######

  @doc """
  Get arrivals from a specific platform at a station, using the station_id
  and the line_id provided here.

  Returns 
  {:ok, %Arrivals{}} if there was a process running for the given platform.
  {:error, :platform_not_found} otherwise.
  """
  def get_arrivals(station_id, line_id) do
    atomize_params(station_id, line_id)
    |> lookup_process()
    |> call_process()
  end

  defp atomize_params(first, second), do: String.to_atom("#{first}_#{second}")

  defp lookup_process(process_name) do
    process_list = Process.registered()
    case Enum.member?(process_list, process_name) do
      false ->
        {:error, :not_found}
      true ->
        {:ok, process_name}
    end
  end

  defp call_process({:ok, name}), do: {:ok, Platform.get_arrivals(name)}
  defp call_process(error), do: error

end
