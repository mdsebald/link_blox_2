defmodule LinkBlox.BlockTypes do

  @moduledoc """
    Common block type utility functions
  """

  @doc """
    Add module_name to list of LinkBlox block types
    Check to make sure module actually implements LinkBlox interface
  """
  @spec add_block_type(atom()) :: :ok | {:error, atom()}
  def add_block_type(_module_name) do
    :ok
  end

  @doc """
    Remove module_name from list of LinkBlox block types
  """
  @spec remove_block_type(atom()) :: :ok | {:error, :not_found}
  def remove_block_type(_module_name) do
    :ok
  end

  @doc """
    Get list of LinkBlox block type modules that exist on this node

    Valid LinkBlox block type modules will export the function link_blox?() which must return `true`
  """
  @spec get_block_types() :: [module()] | []
  def get_block_types() do
    :code.all_loaded()
    |> Enum.filter(fn {module, _file} -> function_exported?(module, :link_blox?, 0) end)
    |> Enum.filter(fn {module, _file} -> module.link_blox?() end)
    |> Enum.map(fn {module, _file} -> module end)
  end
end
