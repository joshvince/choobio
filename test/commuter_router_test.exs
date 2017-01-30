defmodule CommuterRouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Commuter.Router.init([])

  test "returns OK from homepage" do
    #create a test connection
    conn = conn(:get, "/")

    #invoke the plug
    conn = Commuter.Router.call(conn, @opts)

    #assert the response and the status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "OK"
  end

end
