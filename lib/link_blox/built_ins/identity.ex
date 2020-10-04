defmodule LinkBlox.BuiltIns.Identity do
  use LinkBlox,
    version: "0.1.0",
    description: "Sets block ouput value equal to input value"

  @moduledoc """
    Block type `Identity`
    Sets input value to output value on execution
  """

  @doc """
    Create the block, i.e. add the block type specific attributes
    to the common block attributes that have already been created
  """
  def create(attributes) do
    # Only has one input attribute
    Attributes.add(attributes, :input, :inputs, :empty, %{default_value: :empty})
    :ok
  end

  @doc """
    Execute the block, i.e. read inputs and write outputs
  """
  def execute(attributes, :disable) do
    Outputs.update_all_outputs(attributes, nil, :disabled)
  end

  def execute(attributes, _exec_method) do
    case Attributes.get_any_type(attributes, :input) do
      {:ok, value} ->
        Outputs.set_value_normal(attributes, value)

      {:error, _reason} ->
        Outputs.set_value_status(attributes, nil, :input_err)
    end
  end
end
