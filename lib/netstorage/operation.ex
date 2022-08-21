defmodule NetStorage.Operation do
  @moduledoc """
  `Operation` struct defines an action to be perform against the
  Akamai NetStorage API.
  """

  @type t :: %__MODULE__{
          action: action(),
          body: binary(),
          method: :get | :put | :post,
          opts: keyword(),
          parser: function(),
          path: binary(),
          version: integer()
        }

  @type action :: atom() | binary() | keyword()

  defstruct action: nil,
            body: "",
            method: :get,
            opts: [],
            parser: nil,
            path: nil,
            version: 1

  @doc """
  Returns a `Operation` struct with the specified fields.
  """
  @spec new(fields :: keyword()) :: t()
  def new(fields) do
    struct(__MODULE__, fields)
  end

  @doc """
  Returns a `Operation` with the specified action.
  """
  @spec put_action(operation :: t(), action: action()) :: t()
  def put_action(operation, action), do: %{operation | action: action}
end
