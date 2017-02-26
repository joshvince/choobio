defmodule Commuter.Station.ControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Commuter.Station.Controller

  @opts Commuter.Router.init([])

  setup do
    bad_arrivals_resp =
      conn(:get, "/stations/940GZZFAKE/northern")
      |> Commuter.Router.call(@opts)
      |> Controller.get_arrivals
    good_arrivals_resp =
      conn(:get, "stations/940GZZLUTBC/northern")
      |> Commuter.Router.call(@opts)
      |> Controller.get_arrivals
    stations_resp =
      conn(:get, "/stations")
      |> Commuter.Router.call(@opts)
      |> Controller.get_all_stations
    %{responses: %{ bad_arrivals_resp: bad_arrivals_resp,
                    good_arrivals_resp: good_arrivals_resp},
                    stations_resp: stations_resp}
  end

  test "returns 404 if there was not a running station process",
  %{responses: %{bad_arrivals_resp: resp}} do
    assert resp.status == 404
    assert resp.resp_body == "NOT FOUND"
  end

  test "returns 200 and json if there was a running station process",
  %{responses: %{good_arrivals_resp: resp}} do
    assert resp.status == 200
    assert is_binary(resp.resp_body)
  end

  test "puts the potential process id and direction into Conn",
  %{responses: responses} do
    assigns =
      Enum.map(responses, fn {_k,m} -> Enum.into(m.assigns, []) end)
      |> List.flatten
    Enum.each(assigns, fn {_k,v} -> assert is_atom(v) end)
  end

  test "a good request returns valid json",
  %{responses: %{good_arrivals_resp: resp}} do
    {code, _maps} = Poison.decode(resp.resp_body)
    assert code == :ok
  end

  test "a good request returns a string that has station id and name keys",
  %{responses: %{good_arrivals_resp: resp}} do
    parsed_resp = Poison.decode!(resp.resp_body)
    assert Map.has_key?(parsed_resp, "station_name")
    assert Map.has_key?(parsed_resp, "station_id")
  end

  test "a good request returns an object with arrivals map with lists inside",
  %{responses: %{good_arrivals_resp: resp}} do
    arrivals_map =Poison.decode!(resp.resp_body) |> Map.get("arrivals")
    assert Map.has_key?(arrivals_map, "inbound")
    assert Map.has_key?(arrivals_map, "outbound")
  end

  test "the /stations endpoint returns a list of json objects",
  %{stations_resp: resp} do
    {code, _maps} = Poison.decode(resp.resp_body)
    assert code == :ok
  end

end
