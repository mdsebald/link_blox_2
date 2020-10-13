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
    Except set the status output to the given status
    Used to mass update block outputs in disabled or error conditions
  """
  @spec update_all_outputs(attributes(), value(), block_status()) :: :ok
  def update_all_outputs(attributes, new_value, new_status) do
    output_attributes = Attributes.get_class_values(attributes, :outputs)
    Enum.each(output_attributes,
      fn attribute ->
        case attribute do
          [:status, {_old_value, _links}] -> Attributes.set_value(attributes, :status, new_status)
          [name, {_old_value, _links}] -> Attributes.set_value(attributes, name, new_value)
          [name, array_values] -> update_all_array_values(attributes, name, array_values, new_value)
        end
      end)
    :ok
  end

  # Set all of the values in the array to the new value
  @spec update_all_array_values(attributes(), attribute_name(), output_value_array(), value()) :: :ok
  defp update_all_array_values(attributes, name, array_values, new_value) do
    Enum.map_reduce(array_values, 0,
      fn {_old_value, _links}, index ->
        Attributes.set_value(attributes, {name, index+1}, new_value)
      end)
    :ok
  end
end
