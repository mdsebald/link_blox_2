defmodule LinkBlox.Outputs do
  use LinkBlox.Types
  alias LinkBlox.Attributes

  @moduledoc """
    Common block output attributes utility functions
  """

  @doc """
    Set all block outputs to the given value
    Except the status output
  """
  @spec update_all_outputs(attributes(), attribute_value(), block_status()) ::
          :ok | {:error, :error}
  def update_all_outputs(attributes, _value, status) do
    # TODO: Get a list of all of the output attributes and set the value
    Attributes.set_value(attributes, :status, status)
  end

  @doc """
    Set the main block output value and block status to "normal"
  """
  @spec set_value_normal(attributes(), attribute_value()) :: :ok
  def set_value_normal(attributes, value) do
    set_value_status(attributes, value, :normal)
  end

  @doc """
    Set the main block output value and status output attributes
  """
  @spec set_value_status(attributes(), attribute_value(), block_status()) :: :ok
  def set_value_status(attributes, value, status) do
    Attributes.set_value(attributes, :value, value)
    Attributes.set_value(attributes, :status, status)

    :ok
  end
end
