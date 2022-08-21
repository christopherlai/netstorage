defmodule NetStorage.Request do
  @moduledoc false

  @version Keyword.get(Mix.Project.config(), :version)
  @default_headers [
    {"Accept", "application/xml"},
    {"Accept-Encoding", "identity"},
    {"User-Agent", "Elixir NetStorage Client #{@version}"}
  ]

  alias NetStorage.Config
  alias NetStorage.Operation
  alias NetStorage.HackneyClient

  def execute(op, opts \\ []) do
    config =
      if config_opts = opts[:config] do
        Config.new(config_opts)
      else
        Config.new()
      end

    http_otps = http_opts(opts) |> IO.inspect()

    full_path = "/#{config.content_provider_code}#{op.path}"
    headers = build_headers(op, config, full_path)
    url = "http://#{config.host}#{full_path}"

    HackneyClient.request(op.method, url, headers, op.body, http_otps)
  end

  defp build_headers(op, config, full_path, uuid \\ :rand.uniform(100_000)) do
    acs_action = encode_action(op)
    acs_auth_data = "5, 0.0.0.0, 0.0.0.0, #{current_timestamp()}, #{uuid}, #{config.account_id}"
    sign_string = "#{full_path}\nx-akamai-acs-action:#{acs_action}\n"
    message = "#{acs_auth_data}#{sign_string}"

    hash = :crypto.mac(:hmac, :sha256, config.key, message)

    acs_auth_sign = Base.encode64(hash)

    @default_headers ++
      [
        {"X-Akamai-ACS-Action", acs_action},
        {"X-Akamai-ACS-Auth-Data", acs_auth_data},
        {"X-Akamai-ACS-Auth-Sign", acs_auth_sign}
      ]
  end

  defp http_opts(opts) do
    opts[:http_opts] || Application.get_env(:netstorage, :http_opts, [])
  end

  defp encode_action(%Operation{action: action} = op) when is_atom(action) or is_binary(action) do
    op
    |> Operation.put_action(action: action)
    |> encode_action()
  end

  defp encode_action(%Operation{action: action} = op) when is_list(action) do
    op
    |> default_actions()
    |> Kernel.++(action)
    |> Kernel.++(op.opts)
    |> URI.encode_query()
    |> IO.inspect()
  end

  defp default_actions(op), do: [version: op.version]

  defp current_timestamp, do: DateTime.utc_now() |> DateTime.to_unix()
end
