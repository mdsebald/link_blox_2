defmodule LinkBlox.Configs do
  use LinkBlox.Types
  alias LinkBlox.Attributes

  @moduledoc """
    Common block configuration attributes utility functions
  """

  @doc """
    Get block name from the block configuration attributes
  """
  @spec block_name(attributes()) :: block_name() | nil
  def block_name(attributes) do
    case Attributes.get_value(attributes, :block_name) do
      {:ok, block_name} -> block_name
      _error -> nil
    end
  end

  @doc """
    Get block name and block module from the block configuration attributes
  """
  @spec name_module(attributes()) :: {block_name(), module()}
  def name_module(attributes) do
    {:ok, block_name} = Attributes.get_value(attributes, :block_name)
    {:ok, block_module} = Attributes.get_value(attributes, :block_module)
    {block_name, block_module}
  end

  @doc """
    Get block name, block module, and version from the block configuration attributes
  """
  @spec name_module_version(attributes()) :: {block_name(), module(), Version.t()}
  def name_module_version(attributes) do
    {:ok, block_name} = Attributes.get_value(attributes, :block_name)
    {:ok, block_module} = Attributes.get_value(attributes, :block_module)
    {:ok, version} = Attributes.get_value(attributes, :version)
    {block_name, block_module, version}
  end
end
