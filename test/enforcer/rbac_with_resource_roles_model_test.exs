defmodule Acx.Enforcer.RbacWithResourceRolesModelTest do
  use ExUnit.Case, async: true
  alias Acx.Enforcer

  @cfile  "../data/rbac_with_resource_roles.conf" |> Path.expand(__DIR__)
  @pfile  "../data/rbac_with_resource_roles.csv" |> Path.expand(__DIR__)

  setup do
    {:ok, e} = Enforcer.init(@cfile)
    e =
      e
      |> Enforcer.load_policies!(@pfile)
      |> Enforcer.load_mapping_policies!(@pfile)

    {:ok, e: e}
  end

  describe "allow?/2" do
    @test_cases [
      {["alice", "data1", "read"], true},
      {["alice", "data1", "write"], true},
      {["alice", "data2", "read"], false},
      {["alice", "data2", "write"], true},
    ]

    Enum.each(@test_cases, fn {req, res} ->
      test "response `#{res}` for request #{inspect req}", %{e: e} do
        assert e |> Enforcer.allow?(unquote(req)) === unquote(res)
      end
    end)
  end
end
