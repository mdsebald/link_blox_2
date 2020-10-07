defmodule LinkBloxTest.BlockTypeTest do
  use LinkBlox,
    version: "1.2.3",
    description: "Test helper block type, for unit testing LinkBlox code"

  @moduledoc """
    Block type `TestBlockType`
    For unit testing LinkBlox code
  """

  @doc """
    Create the block, i.e. add the block type specific attributes
    to the common block attributes that have already been created
    Add a variety of config, input, output, and private attributes
  """
  def create(attributes) do
    # add configs
    Attributes.create(attributes, :config_int, :configs, 0)
    Attributes.create(attributes, :config_int_array, :configs, [1, 2, 3])

    # add inputs
    Attributes.create(attributes, :input_int, :inputs, {0, 0})
    Attributes.create(attributes, :input_int_array, :inputs, [{1, 1}, {2, 2}, {3, 3}])

    # add outputs
    Attributes.create(attributes, :output_int, :outputs, {0, []})
    Attributes.create(attributes, :output_int_array, :outputs, [{1, []}, {2, []}, {3, []}])
    :ok
  end

  @doc """
    Execute the block, i.e. read inputs and write outputs
  """
  def execute(attributes, :disable) do
    Outputs.update_all_outputs(attributes, nil, :disabled)
  end

  def execute(attributes, _exec_method) do
    case Attributes.get_value(attributes, :some_input_int) do
      {:ok, value} ->
        Outputs.set_value_normal(attributes, value)

      {:error, _reason} ->
        Outputs.set_value_status(attributes, nil, :input_err)
    end
  end
end
