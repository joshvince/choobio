defmodule Choobio do
  @moduledoc """
  Choobio keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Choobio.Station

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

  def get_station!(id), do: Station.get_station!(id)
  def get_station!(id, :lines), do: Station.get_station!(id, :lines)

end
