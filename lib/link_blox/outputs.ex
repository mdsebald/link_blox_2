defmodule LinkBlox.Outputs do
  import LinkBlox.Types
  alias LinkBlox.Attribs

  @moduledoc """
    Common block output attributes utility functions
  """

  @doc """
    Set all block outputs to the given value
    Except the status output
  """
  @spec update_all_outputs(Types.block_attribs(), Types.output_value(), Types.block_status()) :: :ok | {:error, :error}
  def update_all_outputs(attribs, _value, status) do
    # TODO: Get a list of all of the output attributes and set the value
    Attribs.set_value(attribs, :status, status)
  end

  @doc """
    Set the main block output value and block status to "normal"
  """
  @spec set_value_normal(Types.block_attribs(), Types.output_value()) :: :ok
  def set_value_normal(attribs, value) do
    set_value_status(attribs, value, :normal)
  end

  @doc """
    Set the main block output value and status output attributes
  """
  @spec set_value_status(Types.block_attribs(), Types.output_value(), Types.block_status()) :: :ok
  def set_value_status(attribs, value, status) do
    Attribs.set_value(attribs, :value, value)
    Attribs.set_value(attribs, :status, status)

    :ok
  end
end
