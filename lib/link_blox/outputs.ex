defmodule LinkBlox.Outputs do
  use LinkBlox.DataTypes
  alias LinkBlox.Attributes

  @moduledoc """
    Common block output attributes utility functions
  """

  @doc """
    Set the main block output value and status output attributes
  """
  @spec set_value_status(attributes(), value(), block_status()) :: :ok
  def set_value_status(attributes, value, status) do
    Attributes.set_value(attributes, :value, value)
    Attributes.set_value(attributes, :status, status)
    :ok
  end

  @doc """
    Set block output value and set status to normal
    When setting the output value block status is usually normal.
    This is a shortcut to do that.
  """
  @spec set_value_normal(attributes(), value()) :: :ok
  def set_value_normal(attributes, value) do
    set_value_status(attributes, value, :normal)
  end

  @doc """
    Set status output attribute value
  """
  @spec set_status(attributes(), block_status()) :: :ok
  def set_status(attributes, status) do
    Attributes.set_value(attributes, :status, status)
  end


  @doc """
    Get status output attribute value
  """
  @spec get_status(attributes()) :: block_status() | :error
  def get_status(attributes) do
    case Attributes.get_value(attributes, :status) do
      {:ok, status} -> status
      {:error, _reason} -> :error
    end
  end


  @doc """
    Set all block outputs to the given value
    Except the status output
  """
  @spec update_all_outputs(attributes(), value(), block_status()) ::
          :ok | {:error, :error}
  def update_all_outputs(attributes, _value, status) do
    # TODO: Get a list of all of the output attributes and set the value
    Attributes.set_value(attributes, :status, status)
  end
end
