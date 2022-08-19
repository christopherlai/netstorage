defmodule NetStorage.Config do
  @enforce_keys [:content_provider_code, :host, :key, :account_id]
  defstruct [:content_provider_code, :host, :key, :account_id]

  def new, do: struct(__MODULE__, env())

  defp env, do: Application.get_all_env(:netstorage)
end
