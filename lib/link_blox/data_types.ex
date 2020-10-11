defmodule LinkBlox.DataTypes do
  @moduledoc """
    LinkBlox data types
  """

  defmacro __using__(_) do
    quote do
      @typedoc "Block attribute values. Stored in an ETS table"
      @type attributes() :: :erlang.tid()

      @typedoc "Each attribute value is a tuple of name, class, value, and a map of metadata about the attribute"
      @type attribute() ::
              {attribute_name(), attribute_class(), attribute_value(), attribute_metadata()}

      @typedoc "The position of the attribute value in the attribute tuple"
      @value_pos 3

      @typedoc "Attribute name must be unique accross all of a block type's attributes"
      @type attribute_name() :: atom()

      @typedoc "When referencing attributes that are arrays, an index is needed in addition to the attribute name"
      @type attribute_id() :: attribute_name() | {attribute_name(), array_index()}

      @typedoc "Array indexes start from 1"
      @type array_index() :: pos_integer()

      @typedoc "Attribute class. Attributes are divided into configuration, input, output, and private classes"
      @type attribute_class() :: :configs | :inputs | :outputs | :private

      @typedoc "Attribute value is of attribute value type or list of attribute value types"
      @type attribute_value_array() :: [attribute_value()]
      @type attribute_value() :: config_value() | input_value() | output_value() | private_value()

      @type config_value_array() :: [config_value()]
      @type config_value() :: value()

      @type input_value_array() :: [input_value()]
      @type input_value() :: {value(), default_value :: value()}

      @type output_value_array() :: [output_value()]
      @type output_value() :: {value(), link_defs()}

      @type private_value_array() :: [private_value()]
      @type private_value() :: any()

      @type link_defs() :: [link_def()]
      @type link_def() :: {block_name(), attribute_id()}
      @type empty_link() :: {}
      @empty_link {}

      @type block_values() :: [block_value()]
      @type block_value() :: {attribute_id(), value()}

      @type attrib_result_value() :: {:ok, value()} | attrib_errors()

      @type attrib_errors() :: {:error, :not_found | :invalid_value | :invalid_index}

      # Used to read block input values
      @type input_errors() :: {:error, :not_found | :bad_link | :range | :bad_type | :not_input}

      @type generic_input_value() :: {:ok, value()} | {:ok, nil} | input_errors()
      @type integer_input_value() :: {:ok, integer()} | {:ok, nil} | input_errors()
      @type float_input_value() :: {:ok, float()} | {:ok, nil} | input_errors()
      @type boolean_input_value() :: {:ok, boolean()} | {:ok, nil} | input_errors()
      @type string_input_value() :: {:ok, String.t()} | {:ok, nil} | input_errors()

      # Used to read block configuration values
      @type config_errors() :: {:error, :not_found | :range | :bad_type | :not_config}

      @type generic_config_value() :: {:ok, value()} | config_errors()
      @type integer_config_value() :: {:ok, integer()} | config_errors()
      @type float_config_value() :: {:ok, float()} | config_errors()
      @type boolean_config_value() :: {:ok, boolean()} | config_errors()
      @type string_config_value() :: {:ok, String.t()} | config_errors()

      @typedoc "Block name must be unique accross all blocks created on the same node"
      @type block_name() :: atom()

      @typedoc "Attribute value types allowed"
      @type value() ::
              any() | nil
      # | atom()
      # | integer()
      # | float()
      # | boolean()
      # | String.t()
      # | tuple()
      # | list()
      # | reference()
      # | pid()
      # | node()
      # | Version.t()

      @typedoc "Map of key/value pairs definining attribute characteristics"
      @type attribute_metadata() :: map()

      @typedoc """
        Execute method defines the possible reasons for a block to be executed
        "Execute" means to read block input values and update block output values

        manual:     Manually invoked via UI or external application
        input_cos:  One or more input values have changed (i.e. Data Flow)
        timer:      Execution interval timer has timed out
        exec_out:   Exec Input is linked to the Exec Output of
                    a block that has been executed.  (i.e. Control Flow)
        hardware:   Block is connected to HW that can trigger execution
                    i.e. GPIO interrupt
        message:    Block has received a message from a subsystem,
      """

      @type exec_method() :: :manual | :input_cos | :timer | :exec_out | :hardware | :message

      @typedoc """
        Block status defines the possible values for the block status output value

        created:    Block attributes have been instantiated
        initialed:  Block has been initialized, pre execution prep has been completed
        normal:     Block has executed normally
        disabled:   Block disable input is true/on. All block outputs are set to nil
        timeout:    Block values did not get updated from external source, before exec timer expired.
        error:      Block has encountered some error when attempting to execute
        input_err:  One or more of the block input values is incompatible with the block's code
        config_err: One or more of the block configuration values is incompatible with the block's code
        proc_err:   There is an error outside of the block code that is preventing the block from executing
        no_input:   One or more input values are missing, so the block cannot calculate an output
        override:   One or more block output values have been set manually, instead of being calculated
        empty:      Block is about to be deleted
      """

      @type block_status() ::
              :created
              | :initialed
              | :normal
              | :disabled
              | :timeout
              | :error
              | :input_err
              | :config_err
              | :proc_err
              | :no_input
              | :override
              | :empty

      @typedoc """
        Define block type groups, to assist in classifying and organizing block types
        A block type can be assigned to more than one group
      """

      @type type_group() ::
              :none
              | :math
              | :logic
              | :string
              | :conversion
              | :control
              | :input
              | :output
              | :digital
              | :analog
              | :sensor
              | :actuator
              | :composite
              | :i2c
              | :spi
              | :gpio
    end
  end
end
