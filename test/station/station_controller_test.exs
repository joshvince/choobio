defmodule Commuter.Station.ControllerTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias Commuter.Station.Controller

  @tooting "940GZZLUTBC"
  @northern "northern"
  @direction "inbound"
  @opts Commuter.Router.init([])

  # test "returns OK from homepage" do
  #   #create a test connection
  #   conn = conn(:get, "/")
  #
  #   #invoke the plug
  #   conn = Commuter.Router.call(conn, @opts)
  #
  #   #assert the response and the status
  #   assert conn.state == :sent
  #   assert conn.status == 200
  #   assert conn.resp_body == "OK"
  # end

  setup do
    bad_resp =
      conn(:get, "/stations/940GZZFAKE/northern/outbound")
      |> Commuter.Router.call(@opts)
      |> Controller.get_arrivals
    good_resp =
      conn(:get, "stations/940GZZLUTBC/northern/outbound")
      |> Commuter.Router.call(@opts)
      |> Controller.get_arrivals
    %{responses: %{bad_resp: bad_resp, good_resp: good_resp}}
  end

  test "returns 404 if there was not a running station process",
  %{responses: %{bad_resp: resp}} do
    assert resp.status == 404
    assert resp.resp_body == "NOT FOUND"
  end

  test "returns 200 and json if there was a running station process",
  %{responses: %{good_resp: resp}} do
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


end
