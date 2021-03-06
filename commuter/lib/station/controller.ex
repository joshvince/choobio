defmodule Commuter.Station.Controller do
  @moduledoc """
  Handles client requests for station data.
  """

  @doc """
  Handles a request for a list of all stations served by the app and the lines
  for each. Sends JSON array of objects back to the client.
  """
  def get_all_stations(%Plug.Conn{} = conn) do
    Commuter.Tfl.Station.get_all_stations
    |> Poison.encode!
    |> send_response(200, conn)
  end

  @doc """
  Fetches the station, line and direction params from the connection and tries
  to call the corresponding process to retrieve arrivals data.

  Sends a response back to the client - the response is a Station struct encoded
  to a JSON String.
  """
  def get_arrivals(%Plug.Conn{} = conn) do
    conn
    |> assign_arrival_params
    |> lookup_process
  end

  defp assign_arrival_params(%Plug.Conn{path_params: p} = conn) do
    conn
    |> Plug.Conn.assign(:pid, atomize_params({p["station_id"], p["line_id"]}))
  end

  # atomize the params
  defp atomize_params({first, second}) do
    "#{first}_#{second}" |> String.to_atom
  end
  defp atomize_params(one_string), do: String.to_atom(one_string)

  defp lookup_process(%Plug.Conn{assigns: assigns} = conn) do
    process_list = Process.registered
    case Enum.member?(process_list, assigns.pid) do
      false ->
        Plug.Conn.resp(conn, 404, "NOT FOUND")
      true ->
        call_process(conn)
    end
  end

  defp call_process(%Plug.Conn{assigns: assigns} = conn) do
    assigns.pid
    |> Commuter.Station.get_arrivals
    |> Poison.encode!
    |> send_response(200, conn)
  end

  defp send_response(response_body, code, conn) do
    Plug.Conn.resp(conn, code, response_body)
  end

end
