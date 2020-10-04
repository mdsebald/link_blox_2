defmodule LinkBlox.Common do
  use LinkBlox.Types
  alias LinkBlox.Attributes

  @moduledoc """
    Implements LinkBlox functionality common to all block types
  """

  @doc """
    `create()` Create a new block
  """

  @spec create(
          name :: block_name(),
          module :: module(),
          # initial values is a list of key value pairs
          initial_values :: [any()]
        ) :: attributes()

  def create(name, module, _initial_values \\ []) do
    # Create a new list of attributes
    attributes = Attributes.new()

    # This function assumes all Attributes.add() calls do not fail

    # TODO: Check result of Attributes.add()?

    # Create common config attributes
    Attributes.add(attributes, :block_name, :configs, name, %{readonly: true})
    Attributes.add(attributes, :block_module, :configs, module, %{readonly: true})
    Attributes.add(attributes, :version, :configs, module.version(), %{readonly: true})
    Attributes.add(attributes, :description, :configs, "", %{readonly: true})

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
    Attributes.add(attributes, :disable, :inputs, true, %{default_val: true})

    # exec_in:
    # Link exec_in to block that will execute this block.
    # May only be linked to the 'exec_out' block output value
    # value is the name of the block that executed this block
    Attributes.add(attributes, :exec_in, :inputs, :empty, %{default_val: :empty})

    # exec_interval:
    # If > 0, execute block every 'exec_interval' milliseconds.
    # Used to execute a block at fixed intervals
    # instead of being executed via exec_out/exec_in link
    # or executed on change of input values
    Attributes.add(attributes, :exec_interval, :inputs, 0, %{default_val: 0})

    # exec_in and exec_interval may both be used to execute the block.
    # They are not mutually exclusive.
    # If exec_in is linked to another block or exec_interval > 0,
    # the block will no longer execute on change of input state

    # Create common output attributes
    # Output attributes have a calculated value and a list of links to other block inputs

    # Blocks with the 'exec_in' input linked to this output
    # will be executed by this block, each time this block is executed
    # This output may only be linked to exec_in inputs
    # | signal | N/A | N/A |
    Attributes.add(attributes, :exec_out, :outputs, false, %{links: []})
    # | enum | created | created, initialed, normal, ... |
    Attributes.add(attributes, :status, :outputs, :created, %{links: []})
    # | enum | empty | manual, input_cos, timer, ...|
    Attributes.add(attributes, :exec_method, :outputs, :empty, %{links: []})
    # | block type dependent | null | block type dependent |
    Attributes.add(attributes, :value, :outputs, nil, %{links: []})

    # Call the module's create() function to create the attributes specific to the block type
    module.create(attributes)

    # Update the just created block attributes with the initial values

    # Return the attribute list
    attributes
  end
end
