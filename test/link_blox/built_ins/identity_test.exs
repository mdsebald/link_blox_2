defmodule LinkBloxTest.BuiltIns.IdentityTest do
  use ExUnit.Case
  use LinkBlox
  alias LinkBlox.{Common, Attributes}
  doctest LinkBlox

  test "test built-in block type Identity" do
    attributes = Common.create(:test_identity, LinkBlox.BuiltIns.Identity)

    # get common block attribute values
    {:ok, expected_version} = Version.parse("0.1.0")

    assert Configs.name_module_version(attributes) ==
             {:test_identity, LinkBlox.BuiltIns.Identity, expected_version}

    assert Attributes.set_value(attributes, :input, "this is a test") == :ok
    assert LinkBlox.BuiltIns.Identity.execute(attributes, :manual) == :ok
    assert Attributes.get_value(attributes, :value) == {:ok, "this is a test"}
    assert Attributes.get_value(attributes, :status) == {:ok, :normal}
    # assert Attributes.get_value(attributes, :exec_method) == {:ok, :manual}
  end
end
