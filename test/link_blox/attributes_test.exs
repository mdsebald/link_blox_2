defmodule LinkBloxTest.AttributesTest do
  use ExUnit.Case
  use LinkBlox
  alias LinkBlox.{Common, Attributes}
  doctest LinkBlox

  test "test getting and setting block attribute values" do
    attributes = Common.create(:test_block, LinkBloxTest.BlockTypeTest)

    # get common block attribute values
    {:ok, expected_version} = Version.parse("1.2.3")

    assert Configs.name_module_version(attributes) ==
             {:test_block, LinkBloxTest.BlockTypeTest, expected_version}

    assert Attributes.get_value(attributes, :disable) == {:ok, true}
    assert Attributes.get_value(attributes, :exec_interval) == {:ok, 0}
    assert Attributes.get_value(attributes, :value) == {:ok, nil}
    assert Attributes.get_value(attributes, :status) == {:ok, :created}

    # get block type specific attribute values
    #   non-array values
    assert Attributes.get_value(attributes, :not_an_id) == {:error, :not_found}
    assert Attributes.get_value(attributes, :config_int) == {:ok, 0}
    assert Attributes.get_value(attributes, :input_int) == {:ok, 0}
    assert Attributes.get_value(attributes, :output_int) == {:ok, 0}

    #   array values
    assert Attributes.get_value(attributes, {:config_int_array, -1}) == {:error, :invalid_index}
    assert Attributes.get_value(attributes, {:config_int_array, 4}) == {:error, :invalid_index}
    assert Attributes.get_value(attributes, {:config_int_array, 1}) == {:ok, 1}
    assert Attributes.get_value(attributes, {:input_int_array, 2}) == {:ok, 2}
    assert Attributes.get_value(attributes, {:output_int_array, 3}) == {:ok, 3}

    # set block type specific attribute values
    #   non-array values
    assert Attributes.set_value(attributes, :not_an_id, 123) == {:error, :not_found}
    assert Attributes.set_value(attributes, :config_int, 123) == :ok
    assert Attributes.get_value(attributes, :config_int) == {:ok, 123}
    assert Attributes.set_value(attributes, :input_int, -123) == :ok
    assert Attributes.get_value(attributes, :input_int) == {:ok, -123}
    assert Attributes.set_value(attributes, :output_int, 123) == :ok
    assert Attributes.get_value(attributes, :output_int) == {:ok, 123}

    #   array values
    assert Attributes.set_value(attributes, {:config_int_array, -1}, 123) ==
             {:error, :invalid_index}

    assert Attributes.set_value(attributes, {:config_int_array, 4}, 123) ==
             {:error, :invalid_index}

    assert Attributes.set_value(attributes, {:config_int_array, 1}, 123)
    assert Attributes.get_value(attributes, {:config_int_array, 1}) == {:ok, 123}
    assert Attributes.set_value(attributes, {:input_int_array, 2}, -123) == :ok
    assert Attributes.get_value(attributes, {:input_int_array, 2}) == {:ok, -123}
    assert Attributes.set_value(attributes, {:output_int_array, 3}, 123) == :ok
    assert Attributes.get_value(attributes, {:output_int_array, 3}) == {:ok, 123}
  end
end
