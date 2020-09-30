defmodule LinkBlox.Attribs do
  import LinkBlox.Types

  @moduledoc """
    Common block attribute utility functions
  """

  @doc """
    Create new block attribute list
  """
  @spec new() :: Types.block_attribs()
  def new() do
    # store attributes in an ETS table
    # just use default table definitions for now
    :ets.new(:attributes, [])
  end

  @doc """
    Add a new attribute to the list of attributes
  """
  @spec add(Types.block_attribs(), name :: atom(), class :: atom(), value :: term(), opts :: []) :: boolean()
  def add(attribs, name, class, value, opts \\ []) do
    # TODO: Check return value
    :ets.insert_new(attribs, {name, class, value, opts})
  end


  @doc """
    Get block name from attribute values
  """
  @spec name(Types.block_attribs()) :: atom()
  def name(attribs) do
    {:ok, block_name} = get_value(attribs, :block_name)
    block_name
  end

 @doc """
    Get block name and block module from attribute values
  """
  @spec name_module(Types.block_attribs()) :: {atom(), atom()}
  def name_module(attribs) do
    {:ok, block_name} = get_value(attribs, :block_name)
    {:ok, block_module} = get_value(attribs, :block_module)
    {block_name, block_module}
  end

  @doc """
    Get block name, block module, and version from attribute values
  """
  @spec name_module_version(Types.block_attribs()) :: {atom(), atom(), Version.t()}
  def name_module_version(attribs) do
    {:ok, block_name} = get_value(attribs, :block_name)
    {:ok, block_module} = get_value(attribs, :block_module)
    {:ok, version} = get_value(attribs, :version)
    {block_name, block_module, version}
  end


  @doc """
    Get an attribute value of any type
  """
  @spec get_any_type(Types.block_attribs(), Types.attrib_name) :: term()
  def get_any_type(block_attribs, attrib_name) do
    get_value(block_attribs, attrib_name)
  end

  @doc """
    Get an attribute value from the list of attributes
  """
  @spec get_value(Types.block_attribs(), Types.attrib_name()) :: {:ok, Types.attrib_value() | {:error, :error}}
  def get_value(attribs, attrib_name) do
    case :ets.lookup(attribs, attrib_name) do
      [{_name, _class, value, _opts}] -> {:ok, value}

      # TODO: Be more specific about error? What does ets.lookup() return when not found, empty tuple?
      _error -> {:error, :error}

    end
  end

  @doc """
    Set an attribute value in the list of attributes
  """
  @spec set_value(Types.block_attribs(), Types.attrib_name(), Types.attrib_value()) :: :ok | {:error, :error}
  def set_value(attribs, attrib_name, attrib_value) do
    case :ets.update_element(attribs, attrib_name, {3, attrib_value}) do
      true -> :ok

      # TODO: Be more specific about error? What does ets.lookup() return when not found, empty tuple?
      _error -> {:error, :error}

    end
  end
end
