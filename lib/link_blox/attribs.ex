defmodule LinkBlox.Attribs do
  import LinkBlox.Types

  @moduledoc """
    Common block attribute(s)
  """

  @doc """
    Create new block attribute list
  """
  @spec new() :: X.block_attribs()
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
    Get an attribute value from the list of attributes
  """
  @spec get_value(Types.block_attributes(), Types.attrib_name()) :: {:ok, Types.attrib_value() | {:error, :error}}
  def get_value(attribs, attrib_name) do
    case :ets.lookup(attribs, attrib_name) do
      [{_name, _class, value, _opts}] -> {:ok, value}

      # TODO: Be more specific about error? What does ets.lookup() return when not found, empty tuple?
      _error -> {:error, :error}

    end
  end
end
