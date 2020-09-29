defmodule LinkBlox do
  @moduledoc """
    Boiler plate code used to create a LinkBlox compatible block type.
    `use LinkBlox` in your block module code
    and override the `create()`, `upgrade()`, `initialize()`, `execute()`, `delete()`, and `handle_info()` functions
    as necessary to create a custom block type that can be created, modified, and linked to other LinkBlox blocks
  """

  defmacro __using__(module_defs) do
    quote do
      require Logger
      import LinkBlox.Types
      alias LinkBlox.{Common, Attribs, Configs, Inputs, Outputs}

      @doc """
        Define this module as a LinkBLox compatible block type
      """
      @spec link_blox?() :: true
      def link_blox?, do: true

      @doc """
        Get the description of this block type
      """
      @spec description() :: atom()
      def description(), do: Keyword.get(unquote(module_defs), :description, "")

      @doc """
        Get the version of this block module's code
      """
      @spec version() :: Version.t()
      def version(), do: Version.parse!(Keyword.get(unquote(module_defs), :version, "0.1.0"))

      @doc """
        Get the block type group(s) this block type belongs to
      """
      @spec groups() :: [Types.type_group()]
      def groups, do: Keyword.get(unquote(module_defs), :groups, [])

      @doc """
        Create a set of block attributes for this block type

        ## Override this function to create the block type specific attribute

        ## Inititial values are used to override the default attribute values
      """
      @spec create(Types.block_attribs(), []) :: :ok
      def create(attribs, initial_values \\ []) do
        :ok
      end

      @doc """
        Upgrade block attribute values, when block code and block data versions are different

        ## Override this function to change, add, or delete attributes as need to make
           the previous version's attributes compatible with the current version's code

        ## Default is to just change the version in the list of attribute's to match the code's version
      """
      @spec upgrade(Types.block_attribs()) :: :ok | {:error, atom()}
      def upgrade(attribs) do
        module_ver = version()
        {block_name, block_module, block_ver} = Attribs.name_module_version(attribs)

        case Attribs.set_value(attribs, :version, version()) do
          :ok ->
            Logger.info("Block: #{inspect(block_name)} Type: #{inspect(block_module)} Upgraded from: #{inspect(block_ver)} to: #{inspect(module_ver)}")
            :ok

          {:error, reason} ->
            Logger.error("Error: #{inspect(reason)} Upgrading Block: #{inspect(block_name)} Type: #{inspect(block_module)} from: #{inspect(block_ver)} to: #{inspect(module_ver)}")
            {:error, reason}
        end
      end

      @doc """
        Initialize the block attributes prior to starting block execution

        ## Override this function to allocate resources, update attribute values based on related attribute values, etc

        ## `initialize:1` should be called after creation and each time any config value is changed

        For example: if a config value that specifies the quantity of input values changes,
        initialize() must adjust the corresponding list of input values size to match
      """
      @spec initialize(Types.block_attribs()) :: :ok
      def initialize(_attribs) do
        :ok
      end

      @doc """
        Execute the block, i.e. read inputs and write outputs

        ## Override this function to implement the block type specific functionality

        ## Include a function defintion to disable the block, may be block type specific actions to be done on block disable
      """
      @spec execute(Types.block_attribs(), Types.exec_method()) :: :ok | {:error, atom()}
      def execute(attribs, :disable) do
        Attribs.update_all_outputs(attribs, nil, :disabled)
        :ok
      end

      def execute(_attribs, _exec_method) do
        :ok
      end

      @doc """
        Delete the block

        ## Override this function if this block type needs to free block type specific allocated resources, etc
      """
      @spec delete(Types.block_attribs()) :: :ok
      def delete(_attribs) do
        :ok
      end

      @doc """
        Block received a handle_info message

        ## If this block type does not expect handle_info messages, just log a warning

        ## Override this function to handle the message if handle_info messages are expected
      """
      @spec handle_info(info :: term(), Types.block_attribs) :: {:noreply, Types.block_attribs()}
      def handle_info(info, attribs) do
        {block_name, block_module} = Attribs.name_module(attribs)
        Logger.warn("Block type: #{inspect(block_module)} name: #{inspect(block_name)}, received unknown handle_info msg: #{inspect(info)}")
        {:noreply, attribs}
      end

      defoverridable create: 2, upgrade: 1, initialize: 1, execute: 2, delete: 1, handle_info: 2
    end
  end


  @doc """
    Return list of LinkBlox block type modules
  """
  @spec block_types() :: [atom()]
  def block_types() do
    []
  end

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

#  def find_block_type_modules() do
#    with {:ok, list} <- Application.get_key(:my_app, :modules) do
#      list
#      |> Enum.filter(&(&1 |> Module.split() |> Enum.take(1) == ~w|UserHelpers|))
#      |> Enum.reduce(user_data, fn m, acc -> apply(m, :create, acc) end)
#    end
#  end

end
