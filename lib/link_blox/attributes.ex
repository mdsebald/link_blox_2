defmodule LinkBlox.Attributes do
  use LinkBlox.Types

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
    Add a new attribute to the list of attributes
    returns true on success false if attribute name already exists
  """
  @spec add(
          attributes(),
          attribute_name(),
          attribute_class(),
          attribute_value(),
          attribute_metadata()
        ) :: boolean()
  def add(attributes, name, class, value, metadata) do
    :ets.insert_new(attributes, {name, class, value, metadata})
  end

  @doc """
    Get the whole attribute from the list of attributes
    returns true on success false if attribute name does not exist
  """
  @spec get(attributes(), attribute_name()) :: attribute() | nil
  def get(attributes, name) do
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
  @spec update(attributes(), attribute_name(), attribute_value()) :: :ok | {:error, :not_found}
  def update(attributes, name, value) do
    # The
    case :ets.update_element(attributes, name, {@value_pos, value}) do
      true -> :ok
      _error -> {:error, :not_found}
    end
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
    Get an attribute value from the list of attributes
  """
  @spec get_value(attributes(), attribute_id()) ::
          {:ok, attribute_value()} | {:error, :not_found | :invalid_index}
  def get_value(attributes, {name, index}) do
    # array value
    case get(attributes, name) do
      {^name, _class, value, _metadata} ->
        if 0 < index && index <= length(value) do
          # fetch() is zero based, index is 1 based
          Enum.fetch(value, index - 1)
        else
          {:error, :invalid_index}
        end

      nil ->
        {:error, :not_found}
    end
  end

  def get_value(attributes, name) do
    case get(attributes, name) do
      {^name, _class, value, _metadata} -> {:ok, value}
      nil -> {:error, :not_found}
    end
  end

  @doc """
    Get block name from attribute values
  """
  @spec block_name(attributes()) :: block_name() | nil
  def block_name(attributes) do
    case get_value(attributes, :block_name) do
      {:ok, block_name} -> block_name
      _error -> nil
    end
  end

  @doc """
    Get block name and block module from attribute values
  """
  @spec name_module(attributes()) :: {block_name(), module()}
  def name_module(attributes) do
    {:ok, block_name} = get_value(attributes, :block_name)
    {:ok, block_module} = get_value(attributes, :block_module)
    {block_name, block_module}
  end

  @doc """
    Get block name, block module, and version from attribute values
  """
  @spec name_module_version(attributes()) :: {block_name(), module(), Version.t()}
  def name_module_version(attributes) do
    {:ok, block_name} = get_value(attributes, :block_name)
    {:ok, block_module} = get_value(attributes, :block_module)
    {:ok, version} = get_value(attributes, :version)
    {block_name, block_module, version}
  end

  @doc """
    Get an attribute value of any type
  """
  @spec get_any_type(attributes(), attribute_name()) :: term()
  def get_any_type(attributes, name) do
    get_value(attributes, name)
  end

  @doc """
    Set an attribute value in the list of attributes
  """
  @spec set_value(attributes(), attribute_name(), attribute_value()) :: :ok | {:error, :error}
  def set_value(attributes, attrib_name, attrib_value) do
    case :ets.update_element(attributes, attrib_name, {3, attrib_value}) do
      true -> :ok
      # TODO: Be more specific about error? What does ets.lookup() return when not found, empty tuple?
      _error -> {:error, :error}
    end
  end
end
