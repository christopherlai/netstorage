defmodule NetStorage.Config do
  @moduledoc """
  Configuration struct

  ## Set Global Configurations
  To set configurations globally, add your configurations to your
  `config.exs` file.
  ```
  # config/config.exs

  config :netstorage,
    content_provider_code: "123,
    host: "example.akamaihd.net",
    key: "secret-key",
    account_id: "accountid"
  ```

  ## Request Specific Configurations
  To set configurations per request, pass your configurations as an
  option to `NetStorage.request/2`.

      iex> NetStorage.request(operation, [config: [content_provider_code: "123"]])
  """

  @type t :: %__MODULE__{
          content_provider_code: content_provider_code(),
          host: host(),
          key: key(),
          account_id: account_id()
        }

  @type content_provider_code :: binary()
  @type host :: binary()
  @type key :: binary()
  @type account_id :: binary()

  defstruct content_provider_code: "", host: "", key: "", account_id: ""

  @doc """
  Returns a `Config` struct with values populated from the application configs.
  """
  @spec new :: t()
  def new, do: struct(__MODULE__, env())

  @doc """
  Returns a `Config` struct with the specified fields.
  """
  @spec new(fields :: keyword()) :: t()
  def new(fields), do: struct(__MODULE__, fields)

  defp env, do: Application.get_all_env(:netstorage)
end
