defmodule LinkBloxTest do
  use ExUnit.Case
  use LinkBlox
  alias LinkBlox.{Common, Attributes, BuiltIns.Identity}
  doctest LinkBlox

  test "create an Identity type block" do
    attributes = Common.create(:test_identity, Identity)
    assert Attributes.block_name(attributes) == :test_identity
  end

  test "attempt to get invalid attribute fails" do
    attributes = Common.create(:test_identity, Identity)
    assert Attributes.get_value(attributes, 1) == {:error, :not_found}
  end

  test "get value and status outputs" do
    attributes = Common.create(:test_identity, Identity)
    assert Attributes.get_value(attributes, :value) == {:ok, nil}
    assert Attributes.get_value(attributes, :status) == {:ok, :created}
  end
end
