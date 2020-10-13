defmodule LinkBlox.Attributes do
  use LinkBlox.DataTypes

  @moduledoc """
    Common block attribute utility functions
  """

  @doc """
    Create new block attributes list
  """
  @spec new() :: attributes()
  def new() do
    # store attributes in an ETS table
    # just use default table definitions for now
    :ets.new(:attributes, [])
  end

  @doc """
    create a new attribute in the block attributes
    returns true on success false if attribute name already exists
  """
  @spec create(
          attributes(),
          attribute_name(),
          attribute_class(),
          attribute_value() | attribute_value_array(),
          attribute_metadata()
        ) :: boolean()
  def create(attributes, name, class, value, metadata \\ %{}) do
    :ets.insert_new(attributes, {name, class, value, metadata})
  end

  @doc """
    Read the raw attribute tuple from the block attributes
  """
  @spec read(attributes(), attribute_name()) :: attribute() | nil
  def read(attributes, name) do
    # We expect a list of 1 element, anything else is an error
    case :ets.lookup(attributes, name) do
      [attribute] -> attribute
      _error -> nil
    end
  end

  @doc """
    Update an attribute value in the list of attributes
    For array type attribute values, the whole array is updated
  """
  @spec update(attributes(), attribute_name(), attribute_value() | attribute_value_array()) ::
          boolean()
  def update(attributes, name, value) do
    :ets.update_element(attributes, name, {@value_pos, value})
  end

  @doc """
    Delete the attribute from the list of attributes
    returns true on success false if attribute name does not exist
  """
  @spec delete(attributes(), attribute_name()) :: true
  def delete(attributes, name) do
    :ets.delete(attributes, name)
  end

  @doc """
    Get the attribute names and values for the given class
    Returns a list of atrribute name, attribute value lists
  """
  @spec get_class_values(attributes(), attribute_class()) :: list(list(term())) | []
  def get_class_values(attributes, class) do
    :ets.match(attributes, {:"$1", class, :"$2", :_})
  end

  @doc """
    Get an attribute value from the block attributes
  """
  @spec get_value(attributes(), attribute_id()) ::
          {:ok, attribute_value()} | {:error, :not_found | :invalid_index}
  def get_value(attributes, {name, index}) do
    # array value
    case read(attributes, name) do
      {^name, class, values, _metadata} ->
        if 0 < index && index <= length(values) do
          # fetch() is zero based, index is 1 based
          value = :lists.nth(index, values)
          get_class_value(class, value)
        else
          {:error, :invalid_index}
        end

      nil ->
        {:error, :not_found}
    end
  end

  def get_value(attributes, name) do
    # single value
    case read(attributes, name) do
      {^name, class, value, _metadata} -> get_class_value(class, value)
      nil -> {:error, :not_found}
    end
  end

  # Parse out the value, based on the attribute class
  defp get_class_value(:inputs, {value, _default_value}), do: {:ok, value}
  defp get_class_value(:outputs, {value, _links}), do: {:ok, value}
  defp get_class_value(_class, value), do: {:ok, value}

  @doc """
    Set an attribute value in the block attributes
  """
  @spec set_value(attributes(), attribute_id(), value()) ::
          :ok | {:error, :not_found | :invalid_index | :update_failed}
  def set_value(attributes, {name, index}, new_value) do
    # array value
    case read(attributes, name) do
      {^name, class, old_class_values, _metadata} ->
        if 0 < index && index <= length(old_class_values) do
          old_class_value = :lists.nth(index, old_class_values)
          new_class_value = set_class_value(class, old_class_value, new_value)
          new_class_values = replace_array_value(old_class_values, index, new_class_value)

          case update(attributes, name, new_class_values) do
            true -> :ok
            false -> {:error, :update_failed}
          end
        else
          {:error, :invalid_index}
        end

      nil ->
        {:error, :not_found}
    end
  end

  def set_value(attributes, name, new_value) do
    # non-array value
    case read(attributes, name) do
      {^name, class, old_class_value, _metadata} ->
        new_class_value = set_class_value(class, old_class_value, new_value)

        case update(attributes, name, new_class_value) do
          true -> :ok
          false -> {:error, :update_failed}
        end

      nil ->
        {:error, :not_found}
    end
  end

  # Set the value, based on the attribute class
  defp set_class_value(:inputs, {_old_value, default_value}, new_value),
    do: {new_value, default_value}

  defp set_class_value(:outputs, {_old_value, links}, new_value), do: {new_value, links}
  defp set_class_value(_class, _old_value, new_value), do: new_value

  @doc """
    Get an attribute value of any type
  """
  @spec get_any_type(attributes(), attribute_name()) :: term()
  def get_any_type(attributes, name) do
    get_value(attributes, name)
  end

  # replace a value in the array of values
  @spec replace_array_value(attribute_value_array(), array_index(), attribute_value()) ::
          attribute_value_array()
  defp replace_array_value(array_values, index, new_value) do
    length = index - 1

    :lists.sublist(array_values, length) ++
      [new_value] ++
      :lists.nthtail(index, array_values)
  end
end
