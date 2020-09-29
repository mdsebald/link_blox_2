defmodule LinkBlox.Common do
  import LinkBlox.Types

  @moduledoc """
    Implements LinkBlox functionality common to all block types
  """

  @doc """
    `create()` Create a new block
  """

  @spec create(name :: atom(),
               module :: module(),
               version :: String.t(),
               initial_values :: [any()]) :: Types.block_attribs()  # initial values is a list of key value pairs

  def create(name, module, version, _initial_values \\ []) do

    # Create a new list of attributes
    attribs = Attribs.new()

    # This function assumes all Attribs.add() calls do not fail

    # TODO: Check result of Attribs.add()?

    # Create common config attributes
    Attribs.add(attribs, :block_name, :configs, name, [readonly: true])
    Attribs.add(attribs, :block_module, :configs, module, [readonly: true])
    Attribs.add(attribs, :version, :configs, version, [readonly: true])
    Attribs.add(attribs, :description, :configs, "", [readonly: true])

    # Create common input attributes
    # Input attributes have a linked value and default value
    # The default value is used, when the linked value goes missing

    # disable:
    # Block will execute as long as disable input is false/null
    # When disable input is true, all block outputs set to null,
    # and block status is set to disabled.  Block will not execute,
    # Default block to disabled, on create.
    # Set disable input to false in create function if you want block
    # to begin executing on create.
    Attribs.add(attribs, :disable, :inputs, {true, true})

    # exec_in:
    # Link exec_in to block that will execute this block.
    # May only be linked to the 'exec_out' block output value
    # value is the name of the block that executed this block
    Attribs.add(attribs, :exec_in, :inputs, {:empty, :empty})

    # exec_interval:
    # If > 0, execute block every 'exec_interval' milliseconds.
    # Used to execute a block at fixed intervals
    # instead of being executed via exec_out/exec_in link
    # or executed on change of input values
    Attribs.add(attribs, :exec_interval, :inputs, {0, 0})

    # exec_in and exec_interval may both be used to execute the block.
    # They are not mutually exclusive.
    # If exec_in is linked to another block or exec_interval > 0,
    # the block will no longer execute on change of input state

    # Create common output attributes
    # Output attributes have a calculated value and a list of links to other block inputs

    # Blocks with the 'exec_in' input linked to this output
    # will be executed by this block, each time this block is executed
    # This output may only be linked to exec_in inputs
    Attribs.add(attribs, :exec_out, :outputs, {false, []}) #| signal | N/A | N/A |
    Attribs.add(attribs, :status, :outputs, {:created, []})  #| enum | created | created, initialed, normal, ... |
    Attribs.add(attribs, :exec_method, :outputs, {:empty, []})  #| enum | empty | manual, input_cos, timer, ...|
    Attribs.add(attribs, :value, :outputs, {nil, []}) #| block type dependent | null | block type dependent |

    # Call the module's create() function to create the block type specific attributes
    module.create(attribs)

    # Update the just created block attributes with the initial values

    # Return the attribute list
    attribs
  end
end
