defmodule Commuter.Station.ControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Commuter.Station.Controller

  @opts Commuter.Router.init([])

  setup do
    bad_arrivals_resp =
      conn(:get, "/stations/940GZZFAKE/northern/outbound")
      |> Commuter.Router.call(@opts)
      |> Controller.get_arrivals
    good_arrivals_resp =
      conn(:get, "stations/940GZZLUTBC/northern/outbound")
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

  test "a good request returns a string of json objects", %{responses: %{good_arrivals_resp: resp}} do
    {code, _maps} = Poison.decode(resp.resp_body)
    assert code == :ok
  end

  test "the /stations endpoint returns a list of json objects", %{stations_resp: resp} do
    {code, _maps} = Poison.decode(resp.resp_body)
    assert code == :ok
  end


end
